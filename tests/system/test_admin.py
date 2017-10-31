# pylint: disable=redefined-outer-name,unused-variable,expression-not-assigned

from expecter import expect


from . import user


def describe_login():

    def with_valid_credentials():
        user.login('admin', 'password')

        user.visit("/admin")

        expect(user.browser).has_text("demo_project Administration")
        expect(user.browser).has_text("Select a model")

    def with_invalid_credentials():
        user.login('bad-username', 'bad-password')

        user.visit("/admin")

        expect(user.browser.title) == "Log in | demo_project"
        expect(user.browser).has_text("demo_project Administration")
