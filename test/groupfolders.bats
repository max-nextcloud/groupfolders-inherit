#!/usr/bin/env bats
# generated on 2022-11-02T20:59:14Z
load bats-extra

@test 'Process empty!' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -r -f lib/groupfolders.jq << 'END_INPUT'
        {}
END_INPUT
    assert_failure
    assert_output "Could not find permissions for root folder '/'."
}

@test 'No admin group' {
    run jq -rc -f lib/groupfolders.jq << 'END_INPUT'
	{"\/":[{"mapping":{"type":"group","id":"admin"},"mask":2,"permissions":31}]}
END_INPUT
    assert_failure
    assert_output 'Could not find admin group with full permissions.'
}

@test 'Process single entry' {
    run jq -rc -f lib/groupfolders.jq << 'END_INPUT'
	{"\/":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}]}
END_INPUT
    assert_success
    assert_output ''
}

@test 'Process two entries in separate lines' {
    run jq -rc -f lib/groupfolders.jq << 'END_INPUT'
	{
		"\/":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}],
		"dir":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}]
	}
END_INPUT
    assert_success
    assert_output ''
}

@test 'Generates missing line for inheritance' {
    run jq -rc -f lib/groupfolders.jq << 'END_INPUT'
	{
		"\/":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}],
		"dir":[{"mapping":{"type":"group","id":"other"},"mask":21,"permissions":3}]
	}
END_INPUT
    assert_success
    assert_output '{"dir":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}]}'
}

@test 'can handle admin group listed second' {
    run jq -rc -f lib/groupfolders.jq << 'END_INPUT'
	{
		"\/":[{"mapping":{"type":"group","id":"other"},"mask":21,"permissions":3},{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}],
		"dir":[{"mapping":{"type":"group","id":"other"},"mask":21,"permissions":3}]
	}
END_INPUT
    assert_success
    assert_output '{"dir":[{"mapping":{"type":"group","id":"admin"},"mask":0,"permissions":31}]}'
}
