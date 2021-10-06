return {
	lintCommand = "flake8 --stdin-display-name ${INPUT} -",
	lintStdin = true,
	lintIgnoreExitCode = true,
	lintFormats = { "%f:%l:%c: %t%n %m" },
	lintCategoryMap = {
		E = "E",
		F = "E",
		B = "E",
		W = "W",
	},
	prefix = "flake8",
}
