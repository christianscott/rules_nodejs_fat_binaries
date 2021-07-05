"""
"""

def _destination_path(file):
    node_modules_idx = file.path.find("node_modules")
    if file.path.startswith("external") and node_modules_idx != -1:
        # Caveat: this will merge all node_modules/ together
        # TODO: handle multiple node_modules/, retain original structure
        return file.path[node_modules_idx:]
    return file.short_path

def _executable_archive_impl(ctx):
    zip_artifact = ctx.actions.declare_file(ctx.label.name + ".zip")

    all_files = ctx.files.data + ctx.files.entry_point
    cp_files = [
        ("mkdir -p $(dirname ${tmpdir}/%s)\n" % _destination_path(file) +
         "cp %s ${tmpdir}/%s" % (file.path, _destination_path(file)))
        for file in all_files
    ]
    ctx.actions.run_shell(
        inputs = all_files,
        outputs = [zip_artifact],
        command = "\n".join([
            "tmpdir=$(mktemp -d ${TMPDIR:-/tmp}/tmp.XXXXXXXX)",
            "trap \"rm -fr ${tmpdir}\" EXIT",
        ] + cp_files + [
            "find ${tmpdir} -exec touch -t 198001010000.00 '{}' ';'",
            "(d=${PWD}; cd ${tmpdir}; zip -rq ${d}/%s *)" % zip_artifact.path,
        ]),
        mnemonic = "ZipBin",
    )

    launcher = ctx.actions.declare_file("launcher.sh")
    ctx.actions.expand_template(
        template = ctx.file._launcher_template,
        output = launcher,
        substitutions = {
            # TODO: handle node_modules entrypoint
            "{ENTRYPOINT}": ctx.file.entry_point.short_path
        }
    )

    ctx.actions.run_shell(
        inputs = [launcher, zip_artifact],
        outputs = [ctx.outputs.executable],
        command = "\n".join([
            "cat %s %s > %s" % (
                launcher.path,
                zip_artifact.path,
                ctx.outputs.executable.path,
            ),
            "zip -qA %s" % ctx.outputs.executable.path,
            "chmod +x %s" % ctx.outputs.executable.path,
        ]),
        mnemonic = "BuildSelfExtractable",
    )

executable_archive = rule(
    _executable_archive_impl,
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
            default = Label("//tools:executable_archive_tmpl.sh"),
            allow_single_file = True,
        )
    },
)
