# compdef _exiom-ssh exiom-ssh
# compdef _exiom-ssh exiom-rm
# compdef _exiom-ssh exiom-backup
# compdef _exiom-restore exiom-restore

function _exiom-ssh(){
	local state
	_arguments "1: :($(~/.exiom/Interact/exiom-ls --list|  tr '\n' ' '))"
}

function _exiom-restore(){
	local state
	_arguments "1: :($(ls ~/.exiom/boxes/))"
}
function _exiom-deploy(){
	local state
	_arguments "1: :($(ls ~/.exiom/profiles/))"
}