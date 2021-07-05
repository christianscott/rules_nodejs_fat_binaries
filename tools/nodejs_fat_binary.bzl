"""
"""

script_template = """tmpdir=$(mktemp -d ${{TMPDIR:-/tmp}}/tmp.XXXXXXXX)
trap "rm -fr ${{tmpdir}}" EXIT

destination_paths=({destination_paths})
paths=({paths})
for i in {nums}
do
    mkdir -p $(dirname ${{tmpdir}}/${{destination_paths[i]}})
    cp ${{paths[i]}} ${{tmpdir}}/${{destination_paths[i]}}
done

find ${{tmpdir}} -exec touch -t 198001010000.00 '{{}}' ';'
d=${{PWD}}
cd ${{tmpdir}}
zip -rq ${{d}}/{zip_artifact_path} *
"""

def _destination_path(file):
    node_modules_idx = file.path.find("node_modules")
    if file.path.startswith("external") and node_modules_idx != -1:
        # Caveat: this will merge all node_modules/ together
        # TODO: handle multiple node_modules/, retain original structure
        return file.path[node_modules_idx:]
    return file.short_path

def _quote(s):
    return "'{}'".format(s)

def _nodejs_fat_binary_impl(ctx):
    zip_artifact = ctx.actions.declare_file(ctx.label.name + ".zip")
    all_files = ctx.files.data + ctx.files.entry_point
    ctx.actions.run_shell(
        inputs = all_files,
        outputs = [zip_artifact],
        command = script_template.format(
            destination_paths = " ".join([_quote(_destination_path(file)) for file in all_files]),
            paths = " ".join([_quote(file.path) for file in all_files]),
            nums = " ".join([str(i) for i in range(len(all_files))]),
            zip_artifact_path = _quote(zip_artifact.path),
        ),
        mnemonic = "ZipBin",
    )

    launcher = ctx.actions.declare_file("launcher.sh")
    ctx.actions.expand_template(
        template = ctx.file._launcher_template,
        output = launcher,
        substitutions = {
            # TODO: handle node_modules entrypoint
            "{ENTRYPOINT}": ctx.file.entry_point.short_path,
        },
    )

    ctx.actions.run_shell(
        inputs = [launcher, zip_artifact],
        outputs = [ctx.outputs.executable],
        command = "\n".join([
            "cat {} {} > {}".format(
                launcher.path,
                zip_artifact.path,
                ctx.outputs.executable.path,
            ),
            "zip -qA {}".format(ctx.outputs.executable.path),
            "chmod +x {}".format(ctx.outputs.executable.path),
        ]),
        mnemonic = "BuildSelfExtractable",
    )

nodejs_fat_binary = rule(
    _nodejs_fat_binary_impl,
    executable = True,
    attrs = {
        "entry_point": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "data": attr.label_list(
            default = [],
            allow_files = True,
        ),
        "_launcher_template": attr.label(
            default = Label("//tools:nodejs_fat_binary_tmpl.sh"),
            allow_single_file = True,
        ),
    },
)
