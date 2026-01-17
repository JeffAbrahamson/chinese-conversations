# Agents.md

Your job is to implement and maintain the web application shown in
SPEC.md.  You may modify the spec if needed, and if you deviate from
it, you must modify it to conform to the code.

The software must be testable locally in a container by running

    (cd docker && ./docker-manage.sh test)

When you assume that human intervention is needed (for example,
because an external service is required), you must update
TODO-human.md to signal clearly what needs to happen.

Then intended production environment is Cloudflare pages, workers, D1, R2.

To the extent possible, code must have tests.
