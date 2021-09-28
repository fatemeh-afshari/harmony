# Harmony

Harmony is a set of flutter plugins for faster application development.

## Plugins

- [harmony_log](https://github.com/6thsolution/harmony/tree/master/packages/harmony_log)
- [harmony_auth](https://github.com/6thsolution/harmony/tree/master/packages/harmony_auth)
- [harmony_fire](https://github.com/6thsolution/harmony/tree/master/packages/harmony_fire)
- [harmony_login](https://github.com/6thsolution/harmony/tree/master/packages/harmony_login)
- [harmony_login_ui](https://github.com/6thsolution/harmony/tree/master/packages/harmony_login_ui)

## Example

- [example](https://github.com/6thsolution/harmony/tree/master/packages/example)

## Note 
You should consider that these packages not published publicly.
so you can't install them from `pub.dev` site. use the following lines in your `pubspec.yaml` file to install you package:

```yaml
dependencies:
  package_name:
    hosted:
      # this also should be the package name    
      name: package_name
      # our unpub server  
      url: https://unpub.cloud.6thsolution.tech
    version: latest.version
```