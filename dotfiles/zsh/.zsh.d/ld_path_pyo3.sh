# Can use this script to point Bazel sandboxes to the correct tractian_nyquist library files 
# Unnecessary after using this command to add the absolute path to the .so file:

# install_name_tool -add_rpath /Users/tyleranderton/.local/share/uv/python/cpython-3.10.19-macos-aarch64-none/lib \
# /Users/tyleranderton/Repositories/tractian-ai/.venv/lib/python3.10/site-packages/tractian_nyquist/tractian_nyquist.so

# PYTHON_LIBDIR=$(python3 -c 'import sysconfig; print(sysconfig.get_config_var("LIBDIR"))')
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "macos"
#     export DYLD_LIBRARY_PATH="/Users/tyleranderton/.local/share/uv/python/cpython-3.10.19-macos-aarch64-none/lib"
#     echo "DYLD_LIBRARY_PATH: $DYLD_LIBRARY_PATH"
# else
#     echo "linux"
#     export LD_LIBRARY_PATH="${PYTHON_LIBDIR}:$LD_LIBRARY_PATH"
# fi
