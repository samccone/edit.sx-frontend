Editor Client
=================

This is the frontend application for http://edit.sx/

### Dev
- npm install
- npm run-script bower-install
- set your ENV keys

```bash
export PARSE_APP_ID=""
export PARSE_JS_KEY=""
export RAVEN_ID=""
```

- npm run-script watch

### Deployment
- npm run-script bower-install
- ROOTS_ENV=PRODUCTION roots compile

### View Code Organization
- admin_editor: the admin edit master tool
- public_editor: the public editor that sits on an admin edit

