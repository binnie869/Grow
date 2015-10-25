Package.describe({
  name: 'core',
  version: '0.1.0'
});

Package.onUse(function (api) {
  api.versionsFrom('1.2.0.2');

  // Core dependencies.
  api.use([
    'coffeescript',
    'accounts-base',
    'ddp-client',
    'underscore'
  ]);

  // 3rd party dependencies.
  api.use([
    'peerlibrary:peerdb@0.19.1'
  ]);

  // Internal dependencies.
  api.use([
  ]);

  api.export('User');
  api.export('Device');
  api.export('Data');
  api.export('Message');

  api.addFiles([
    'base.coffee',
    'documents/user.coffee',
    'documents/device.coffee',
    'documents/data.coffee',
    'documents/messages.coffee'
  ]);
});