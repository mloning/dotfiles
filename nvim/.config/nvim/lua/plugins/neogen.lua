return {
  { -- further customize the options set by the community
    "neogen",
    opts = {
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = "numpydoc",
          },
        },
      },
    },
  },
}
