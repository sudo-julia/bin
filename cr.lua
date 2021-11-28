#!/usr/bin/env lua
-- compile and run a program with cc

local format = require("string").format
local os = require("os")
local path = require("pl.path")
local stringx = require("pl.stringx")
local utils = require("pl.utils")

local function valid_filetype(file)
	-- check if a file can be compiled by cc, returns true on success, false on fail
	local valid_fts = { "c", "cpp" }
	local ft_table = stringx.split(file, ".") -- split a file on the periods
	local ft = ft_table[#ft_table] -- get the value of the last field
	local is_valid = false
	for _, v in ipairs(valid_fts) do
		if v == ft then
			is_valid = true
			break
		end
	end
	return { is_valid, ft }
end

local function parse_args()
	-- parse arguments and return the table of args
	local argparse = require("argparse")
	local parser = argparse()({
		name = "cr",
		description = "compile and run a c program",
	})
	-- arguments
	parser:argument("file", "The file to compile and run."):args(1)

	-- flags
	parser:flag("-t --tmp", "Run the file in a tmp directory.")

	return parser:parse()
end

local function die(msg)
	local stderr = require("io").stderr
	-- print an err to stderr and exit with failure
	stderr:write(format("[ERR] %s", msg))
	os.exit(1)
end

local function compile(file, compile_dir, compiler_flags)
	-- compile a program
	if not compiler_flags then
		compiler_flags = string.format("-Wall -Werror -O2 -std=c99 -pedantic -o %s %s", file, compile_dir)
	end
	local command = string.format("cc %s", compiler_flags)
	local success, exit_code, stdout, stderr = utils.executeex(command, true)
	if not success then
		return {
			true,
			string.format("'%s' exited with code %d.\nstdout:\t%s\nstderr:\t%s\n", command, exit_code, stdout, stderr),
		}
	end
	return { false, stdout }
end

local function main()
	-- main operations
	-- TODO: switch arg parsing to pl.app.parse_args
	local args = parse_args()
	local file = args.file
	-- make sure we can work with the file
	if not path.exists(file) then
		die(format("File '%s' does not exist\n", file))
	end

	do
		local valid, ft = valid_filetype(file)
		if not valid then
			die(format("'%s' is not a filetype supported by cr.", ft))
		end
	end

	local compile_dir
	if not args.tmp then
		compile_dir = "./build"
	else
		compile_dir = "/tmp" -- TODO: standardize
	end

	do
		local err, output = compile(file, compile_dir)
		if err then
			die(output)
		else
			print("")
		end
	end
end

main()
