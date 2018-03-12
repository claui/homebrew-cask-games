#!/bin/bash
set -eu

PKGNAME='steamed-hams'
APPNAME_UPSTREAM='Steamed Hams'
EXE="C:/Games/${APPNAME_UPSTREAM}/SteamedHams.exe"

echo >&2 "Initializing"

RESOURCES_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../Resources"
  pwd
)"

WORKDIR="$(
  osascript -e "POSIX path of (path to application support folder`
    ` from user domain)"
)${APPNAME_UPSTREAM}"

export WINEARCH='win32'
export WINEPREFIX="${WORKDIR}/wine"

APPDIR_PARENT="${WINEPREFIX}/drive_c/Games"

USER_LOGDIR="${WORKDIR}/log"
USER_LOGFILE_STDOUT="${USER_LOGDIR}/${PKGNAME}_out.log"
USER_LOGFILE_STDERR="${USER_LOGDIR}/${PKGNAME}_err.log"

mkdir -p "${USER_LOGDIR}"
: > "${USER_LOGFILE_STDOUT}"
: > "${USER_LOGFILE_STDERR}"

echo >&2 "Logging stdout to: ${USER_LOGFILE_STDOUT}"
echo >&2 "Logging stderr to: ${USER_LOGFILE_STDERR}"

echo >&2 "Checking for Homebrew prefix"

{
  printf 'Original PATH: %s\n' "${PATH}"
  export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"
  printf 'Modified PATH: %s\n' "${PATH}"
  printf 'Homebrew prefix: %s\n' "$(brew --prefix)"
} \
  >> "${USER_LOGFILE_STDOUT}" 2>> "${USER_LOGFILE_STDERR}"

echo >&2 "Checking for Wine prefix"

if ! [ -d "${WINEPREFIX}" ]; then
  echo >&2 "==> Bootstrapping Wine prefix"
  (
    mkdir -pv "${WINEPREFIX}"
    wineboot -i
    rm -fv "${WINEPREFIX}/dosdevices/z:"
  ) >> "${USER_LOGFILE_STDOUT}" 2>> "${USER_LOGFILE_STDERR}"
  echo >&2 "==> Done"
fi

echo >&2 "==> Creating symlink to app directory"
(
  mkdir -pv "${APPDIR_PARENT}"
  ln -fnsv "${RESOURCES_DIR}" \
    "${APPDIR_PARENT}/${APPNAME_UPSTREAM}"
) >> "${USER_LOGFILE_STDOUT}" 2>> "${USER_LOGFILE_STDERR}"

echo >&2 "Launching ${APPNAME_UPSTREAM} via Wine"

exec wine "${EXE}" \
  >> "${USER_LOGFILE_STDOUT}" 2>> "${USER_LOGFILE_STDERR}"
