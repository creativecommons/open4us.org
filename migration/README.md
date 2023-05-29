# Migration

This site was migrated from WordPress hosted on Pantheon to static files hosted
on GitHub Pages.

Pantheon was dropped as a vendor due to their enabling of hate: [WebOps
platform Pantheon defends hosting “hate groups” as developers quit | Ars
Technica][ars].

[ars]: https://arstechnica.com/tech-policy/2023/04/webops-platform-pantheon-defends-hosting-hate-groups-as-developers-quit/


## WordPress repository

The old WordPress repository was archived:
[cc-archive/open4us-wordpress][ccarchive].

[ccarchive]: https://github.com/cc-archive/open4us-wordpress


## Migration process

Process to migrate from WordPress to static files:

1. Ran site locally using [lando][lando]
2. Installed [Simply Static][simplystatic] WordPress plugin
   - Add additional **URLs to Exclude**:
        ```
        https://open4us.lndo.site/xmlrpc.php
        https://open4us.lndo.site/wp-includes/wlwmanifest.xml
        https://open4us.lndo.site/comments/feed/
        ```
3. Downloaded generated Simply Static zip file and moved contents into `docs/`
4. Corrected permissions:
    ```shell
    find docs -type f -exec chmod -x {} +
    ```
5. Added `docs/.nojekyll` (empty file)
6. Export files from Panethon and add all files within `wp-content/uploads/`
7. Add missing JavaScript file:
   - https://github.com/creativecommons/open4us.org/commit/da8d72cd22b3f0b7ef09c3dc967c82f6e645f7e3
7. Ran `./migration/migration/cleanup_html.sh`
   - Remove deprected links and meta from HTML files
   - Clean-up whitespace in plaintext files

[land]: https://lando.dev/
[simplystatic]: https://wordpress.org/plugins/simply-static/
