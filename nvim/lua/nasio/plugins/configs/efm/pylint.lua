return {
	lintCommand = "pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
	lintStdin = false,
	lintOffsetColumns = 1,
	lintFormats = { "%f:%l:%c:%t:%m" },
	lintCategoryMap = {
    I = "H",
    R = "I",
    C = "I",
		W = "W",
		E = "E",
		F = "E",
	},
	prefix = "pylint",
}
