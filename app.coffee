ignore_files: ['_*', 'readme*', '.gitignore', '.DS_Store', 'layout.jade']
ignore_folders: ['.git', 'node_modules', 'bower_components']

watcher_ignore_folders: ['components', "node_modules", "bower_components"]

locals:
  title: 'Edit.sx – Collaborative Photo Editing'
  parseAppID: process.env.PARSE_APP_ID
  parseJSKey: process.env.PARSE_JS_KEY
  RAVEN_ID: process.env.RAVEN_ID

templates: 'assets/js/templates'
