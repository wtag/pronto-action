# Upgrade Pronto Action

1. Run `bundle update`
2. Commit your changes & open PR
3. Pass QA & Merge PR

## Acceptance Criteria

If the `docker run ...` command complains about the line length being too long, all is good:

```shell
# Run the docker build:
docker build -t pronto-action-local .

{
cat <<EOF > test.rb
puts "Pronto should not be happy with this as it has double quotes and is super duper long. Yep, this is a long text!"
EOF

git add test.rb

docker run -v "$(pwd)"/:/test-app -it --entrypoint pronto pronto-action-local run --staged /test-app/test.rb

git rm -f test.rb
}
```
