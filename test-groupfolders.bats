#!/usr/bin/env bats
# generated on 2022-11-02T20:59:14Z
load bats-extra

@test 'Process empty!' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -r -f groupfolders.jq << 'END_INPUT'
        {}
END_INPUT
    assert_success
    assert_output ''
}

@test 'Process single entry' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f groupfolders.jq << 'END_INPUT'
	{"\/":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}]}
END_INPUT
    assert_success
    assert_output ''
}

## FIXME: this should return nothing as the mapping is the same.
@test 'Process two entries in separate lines' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f groupfolders.jq << 'END_INPUT'
	{
		"\/":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}],
		"dir":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}]
	}
END_INPUT
    assert_success
    assert_output '{"dir":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}]}'
}

@test 'Generates missing line for inheritance' {
    #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
    run jq -rc -f groupfolders.jq << 'END_INPUT'
	{
		"\/":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}],
		"dir":[{"mapping":{"type":"group","id":"other"},"mask":21,"permissions":3}]
	}
END_INPUT
    assert_success
    assert_output '{"dir":[{"mapping":{"type":"group","id":"admin"},"mask":24,"permissions":7}]}'
}
