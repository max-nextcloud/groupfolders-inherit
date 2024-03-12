#!/usr/bin/env bats
# generated on 2022-11-02T20:59:14Z
load bats-extra

@test 'Process empty!' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -r -f ancestors.jq << 'END_INPUT'
{}
END_INPUT
    assert_success
    assert_output ''
}

@test 'Process single entry as is' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f ancestors.jq << 'END_INPUT'
{
	"hello": "world"
}
END_INPUT
    assert_success
    assert_output '{"hello":{"value":"world"}}'
}

@test 'Sort entries' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f ancestors.jq << 'END_INPUT'
{
	"hello": "world",
	"a": "root",
	"bla": "bla"
}
END_INPUT
    assert_success
    assert_line --index 0 --partial '{"a":'
    assert_line --index 1 --partial '{"bla":'
    assert_line --index 2 --partial '{"hello"'
}

@test 'clear root /' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f ancestors.jq << 'END_INPUT'
{
	"/": "root"
}
END_INPUT
    assert_success
    assert_line '{"":{"value":"root"}}'
}

@test 'Adds parent to entry' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f ancestors.jq << 'END_INPUT'
{
	"hello": "world",
	"/": "root",
	"bla": "bla"
}
END_INPUT
    assert_success
    assert_line --partial '{"bla":{"value":"bla","parent":'
    assert_line --partial '{"hello":{"value":"world","parent":{'
}

@test 'Adds parent to entry with nesting' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f ancestors.jq << 'END_INPUT'
{
	"hello": "world",
	"/": "root",
	"bla": "bla",
	"bla/blub": "blub"
}
END_INPUT
    assert_success
    assert_line --partial '{"blub":{"value":"blub","parent":'
    assert_line --partial '{"hello":{"value":"world","parent":{'
}

