local status_ok, gen = pcall(require, "gen")
if not status_ok then
    return
end

gen.prompts["Fix_Code"] = {
    prompt = "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
    model = "codellama",
}
