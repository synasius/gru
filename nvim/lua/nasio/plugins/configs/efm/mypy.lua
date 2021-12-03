return {
	lintCommand = "mypy --show-column-numbers --strict --namespace-packages",
	lintFormats = {
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l:%c: %tote: %m",
	},
  prefix = "mypy",
}
