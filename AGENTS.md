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


Consider the possibility that you are running in a docker container
and that changes you make other than to the file system will not be
persistent.  If you need new software packages, consider if you can
install them locally to avoid requiring additional permissions.  If
you believe the packages should be persisted, add the instructions to
the Dockerfile or onen of its supporting files.

If you can't continue without new software, then update the docker
contents, write a file TODO-claude.md with information for yourself on
your next invocation, so that I can just say "read TODO-claude.md and
continue".  Then request that your container be restarted.
