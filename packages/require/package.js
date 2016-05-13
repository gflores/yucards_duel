
Package.describe({
  summary: "REVAMP A simple tool to define/require modules with dependencies",
  version: "0.0.1",
  name: "my:define",
  git: "https://github.com/apendua/require.git"
});

Package.on_use(function (api) {
  if (api.versionsFrom) {
    api.versionsFrom("METEOR@0.9.0");
  }

  api.use(['deps', 'underscore', 'amd:manager@0.0.5'], ['client', 'server']);
  
  api.add_files([

    'require.js',

  ], ['client', 'server']);

  if (api.export !== undefined) {
    api.export('DEF', ['client', 'server']);
    api.export('REQ', ['client', 'server']);
  }
});
