current_chart = './charts/maikr'

print("""
-----------------------------------------------------------------
✨ Hello Tilt! This appears in the (Tiltfile) pane whenever Tilt
   evaluates this file.
-----------------------------------------------------------------
""".strip())
warn('ℹ️ Open {tiltfile_path} in your favorite editor to get started.'.format(
    tiltfile_path=config.main_path))

local_resource('install-helm',
               cmd='which helm > /dev/null || brew install helm',
               # `cmd_bat`, when present, is used instead of `cmd` on Windows.
               cmd_bat=[
                   'powershell.exe',
                   '-Noninteractive',
                   '-Command',
                   '& {if (!(Get-Command helm -ErrorAction SilentlyContinue)) {scoop install helm}}'
               ]
)

k8s_yaml(helm(current_chart))