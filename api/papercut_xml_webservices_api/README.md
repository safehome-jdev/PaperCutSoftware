# PaperCut XML WebServices API

[![image](https://img.shields.io/pypi/v/papercut_xml_webservices_api.svg)](https://pypi.python.org/pypi/papercut_xml_webservices_api)

[![image](https://img.shields.io/travis/safehome_jdev/PaperCutSoftware/api/papercut_xml_webservices_api.svg)](https://travis-ci.com/safehome_jdev/PaperCutSoftware/api/papercut_xml_webservices_api/)

* Free software: MIT license
* [Documentation](https://github.com/safehome-jdev/PaperCutSoftware/blob/main/API/README.md)
* [PaperCut API Docs](https://www.papercut.com/help/manuals/ng-mf/common/tools-web-services/)

## Overview
PaperCut NG/MF server's API uses XML-RPC. This library utilizes Python's [stable XMLRPC library](https://python.readthedocs.io/en/stable/library/xmlrpc.html).

API methods are accessed by NG/MF's `rpc/api/xmlrpc` endpoint:

| http                                       | https                                       |
|--------------------------------------------|---------------------------------------------|
| `http://[server_name]:9191/rpc/api/xmlrpc` | `https://[server_name]:9192/rpc/api/xmlrpc` |

Ensure you are making your API call from [an authorized address](https://www.papercut.com/help/manuals/ng-mf/common/tools-web-services/#tools-web-services-examples).

## How-To

1. Provide your basic `ServerCommandProxy` parameters

```python
api = ServerCommandProxy(
    host="papercut.mydomain.com", port=443, ssl=True,
)
```

2. With `ServerCommandProxy` parameters set, we can now instantiate it and call up the methods:

```python
with api:
    print(api.setUserProperty(
        authToken="myToken",
        userName="safehome-jdev",
        propertyName="email",
        propertyValue="jdev@email.com"
        ))
```

3. Here's an example that requires just the `authToken`

```python
"""
Example Script
"""

from papercut_xml_webservices_api.ServerCommand.ServerCommandProxy import (
    ServerCommandProxy,
)

api = ServerCommandProxy(
    host="papercut.domain.com", port=443, ssl=True,
)

with api:
    print(
        api.getUserGroups(
            authToken="myToken", userName="safehome-jdev"
        )
    )

```

## Security

PaperCut NG/MF secures access using two security layers:

- Source IP address
- Authentication tokens

The Source IP level is used by denoting IP addresses which are allowed to connect to the App server's API endpoint and call the methods. By default, this is restricted to [localhost](127.0.0.1) only. If the tool utilizing this library resides on another system, ensure to add that system’s IP address to the list of approved addresses under:

> `Options > Advanced > Allowed XML Web Services callers`

The first parameter to all methods is the authentication token (`authToken`). You should define your authentication tokens with the advanced configuration editor.

To configure you `authToken` parameter:

1. Click the `Options` tab. The `General` page is displayed.
2. In the `Actions` menu, click `Config editor (advanced)`.

    ![The `Config Editor` page is displayed.](https://cdn1.papercut.com/web/img/support/resources/manuals/ng-mf/options-general-config-editor-17-0-0.png)

3. Find the `auth.webservices.auth-token` config key.
4. In `Value`, enter the new Web Services authentication token. See below for the supported formats.
5. Click `Update` to the right of `Value` to apply the change.
   1. This authentication token can now be used in addition to the built-in admin user’s password.

Auth tokens can be configured in three different formats:

- JSON
- string
- array

The most flexible, and recommended, approach is a JSON object that lists the name of the applications and the tokens they use.

### JSON

```json
{
 "payments":"Zuj0hiazoo5hahwa",
 "userUpdate":"heitieGuacoh8zo6"
}
```

> 🖋️ Note
>
> - PaperCut NG/MF ignores the application names (`payments` and `userUpdate` in the above example) during validation. The JSON keys are supported to help the PaperCut NG/MF administrator keep a record of which API applications are using the various tokens (values).
>
> - A token value can be used by more than one application, but the application name must be unique. When an API call is made PaperCut NG/MF will record the application name in the server log for auditing purposes when debug is enabled. Debug can be enabled in the Application server logs via **Options > Advanced**.

### Array

- If you don’t need to keep a record of which applications are using the various tokens, you can specify the tokens as a simple array. For example:

> `auth.webservices.auth-token`

```json
[
 "Zuj0hiazoo5hahwa","heitieGuacoh8zo6"
]
```

### String

- This feature is provided for backwards compatibility. It is possible to provide a single token as a string that is shared across all API applications. For example:

> `auth.webservices.auth-token`

```string
Zuj0hiazoo5hahwa
```

> 🖋️ Note
>
> - If a Web Services authentication token is not available, then you can use the built-in `admin` user’s password. This is the password defined during the initial installation configuration wizard.
>
> 🛑 Security Risk
>
> - Using the admin password could be a security risk if the password leaks. The admin password is significantly slower because the auth token requires additional processing on each call.

Credits
-------

This package was created with [Cookiecutter](https://github.com/audreyr/cookiecutter) and the [`audreyr/cookiecutter-pypackage`](https://github.com/audreyr/cookiecutter-pypackage) project template.
