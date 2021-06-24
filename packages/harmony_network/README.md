# harmony_network
harmony's command line tool to generate a dio based flutter network client from an openapi sepcifications yaml file

## Install

`NOTE: since we are using open-api cli to generate the network module we need java to be installed on our machine and added to path. otherwise network module cannot be generated`

you can install harmony_network from pub <span style="color:red;font-size:12px">( not available yet )</span>
```yaml
dev_dependencies:
  harmony_network: ^x.y.z
```

or you could install it directly from github
```yaml
dev_dependencies:
  harmony_network:
    git:
      url: git@github.com:6thsolution/harmony.git
      path: packages/harmony_network
      ref: master
```
## Get Started

### step 1
in your project`pubspec.yaml` file add the configuration needed for harmony_network
```yaml
harmony_network:
  openapi_file_path: path/to/openapi_spec.yaml
  output_path: modules/network # your network package will be generated here
  module_name: booksapi # pub package name
  author_name: alireza # (optional) pub author name
  skip_validation: true # (optional) if true openapi file validation will be skipped. (it is set to false by default)
```

### step 2
then from your terminal just run :

```
$ flutter pub run harmony_network:main
```
when you run this command basically 4 steps are going to be taken to create the network module out of your openapi specification file
- config you defined will be gathered from the pubspec.yaml file of your project
- your module will be genrated in the specified path
- command `flutter pub get` will run in generated module
- command `flutter pub run build_runner build --delete-conflicting-outputs` will run in generated module

### step 3 

check out the generated module for syntax errors if errors could be fixed on your side fix them. like adding a missing import or something

if errors cannot be fixed by you - the front end dev - and openapi specification file needs to be changed to fix the errors, contact the back-end developer of the project or the responisble person





