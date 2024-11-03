--  _   _                 _            
-- | \ | | ___  _____   _(_)_ __ ___   
-- |  \| |/ _ \/ _ \ \ / / | '_ ` _ \  
-- | |\  |  __/ (_) \ V /| | | | | | | 
-- |_| \_|\___|\___/ \_/ |_|_| |_| |_| 
--                                     
-- by Stephan Raabe (2023)
-- ----------------------------------------------------- 

-- Copy and paste?
-- Map Ctrl+C to yank to clipboard in normal and visual mode
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+V to paste from clipboard in normal mode
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })

-- Map Ctrl+V to paste from clipboard in Insert mode
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Add numbers to the side
vim.opt.number = true

-- Disable compatibility with vi which can cause unexpected issues.
vim.opt.compatible = false

-- Enable type file detection. Vim will be able to try to detect the type of file in use.
vim.cmd('filetype on')

-- Enable plugins and load plugin for the detected file type.
vim.cmd('filetype plugin on')

-- Load an indent file for the detected file type.
vim.cmd('filetype indent on')

-- Turn syntax highlighting on.
vim.cmd('syntax on')

-- Set shift width to 4 spaces.
vim.opt.shiftwidth = 4

-- Set tab width to 4 columns.
vim.opt.tabstop = 4

-- Use space characters instead of tabs.
vim.opt.expandtab = true

-- Do not save backup files.
vim.opt.backup = false

-- Do not let cursor scroll below or above N number of lines when scrolling.
vim.opt.scrolloff = 10

-- Set Mouse support
vim.opt.mouse = 'a'

-- Do not wrap lines. Allow long lines to extend as far as the line goes.
-- vim.opt.wrap = false  -- Uncomment this if you don't want line wrapping

-- While searching through a file incrementally highlight matching characters as you type.
vim.opt.incsearch = true

-- Ignore capital letters during search.
vim.opt.ignorecase = true

-- Override the ignorecase option if searching for capital letters.
-- This will allow you to search specifically for capital letters.
vim.opt.smartcase = true

-- Show partial command you type in the last line of the screen.
vim.opt.showcmd = true

-- Show the mode you are in on the last line.
vim.opt.showmode = true

-- Show matching words during a search.
vim.opt.showmatch = true

-- Use highlighting when doing a search.
vim.opt.hlsearch = true

-- Set the commands to save in history. The default number is 20.
vim.opt.history = 1000
