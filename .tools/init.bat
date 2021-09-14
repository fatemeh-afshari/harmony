@echo off

echo HEADER init

pushd packages || exit 1

pushd harmony_log || exit 1
echo NOTE harmony_log
call flutter pub get || exit 1
popd || exit 1

pushd harmony_auth || exit 1
echo NOTE harmony_auth
call flutter pub get || exit 1
popd || exit 1

pushd harmony_fire || exit 1
echo NOTE harmony_fire
call flutter pub get || exit 1
popd || exit 1

pushd harmony_login || exit 1
echo NOTE harmony_login
call flutter pub get || exit 1
popd || exit 1

pushd harmony_login_ui || exit 1
echo NOTE harmony_login_ui
call flutter pub get || exit 1
popd || exit 1

popd || exit 1
