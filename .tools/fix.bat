@echo off

echo HEADER init

pushd packages || exit 1

pushd harmony_log || exit 1
echo NOTE harmony_log
call dart format --fix lib test guide
popd || exit 1

pushd harmony_auth || exit 1
echo NOTE harmony_auth
call dart format --fix lib test guide
popd || exit 1

pushd harmony_fire || exit 1
echo NOTE harmony_fire
call dart format --fix lib test guide
popd || exit 1

pushd harmony_login || exit 1
echo NOTE harmony_login
call dart format --fix lib test guide
popd || exit 1

pushd harmony_login_ui || exit 1
echo NOTE harmony_login_ui
call dart format --fix lib test guide
popd || exit 1

popd || exit 1
