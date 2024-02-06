return {
    { 
        "frabjous/knap",
        lazy = true,
        config = function()
            local kmap = vim.keymap.set

            -- F5 processes the document once, and refreshes the view
            kmap({ 'n', 'v', 'i' },'<F5>', function() require("knap").process_once() end)

            -- F6 closes the viewer application, and allows settings to be reset
            kmap({ 'n', 'v', 'i' },'<F6>', function() require("knap").close_viewer() end)

            -- F7 toggles the auto-processing on and off
            kmap({ 'n', 'v', 'i' },'<F7>', function() require("knap").toggle_autopreviewing() end)

            -- F8 invokes a SyncTeX forward search, or similar, where appropriate
            kmap({ 'n', 'v', 'i' },'<F8>', function() require("knap").forward_jump() end)

            local gknapsettings = {
                htmloutputext = "html",
                htmltohtml = "none",
                htmltohtmlviewerlaunch = "falkon %outputfile%",
                htmltohtmlviewerrefresh = "none",
                mdoutputext = "html",
                mdtohtml = "pandoc --standalone %docroot% -o %outputfile%",
                mdtohtmlviewerlaunch = "falkon %outputfile%",
                mdtohtmlviewerrefresh = "none",
                mdtopdf = "pandoc %docroot% -o %outputfile%",
                mdtopdfviewerlaunch = "sioyek %outputfile%",
                mdtopdfviewerrefresh = "none",
                markdownoutputext = "html",
                markdowntohtml = "pandoc --standalone %docroot% -o %outputfile%",
                markdowntohtmlviewerlaunch = "falkon %outputfile%",
                markdowntohtmlviewerrefresh = "none",
                markdowntopdf = "pandoc %docroot% -o %outputfile%",
                markdowntopdfviewerlaunch = "sioyek %outputfile%",
                markdowntopdfviewerrefresh = "none",
                texoutputext = "pdf",
                textopdf = "pdflatex -interaction=batchmode -halt-on-error -synctex=1 %docroot%",
                textopdfviewerlaunch = "evince %outputfile%",
                textopdfviewerrefresh = "none",
                textopdfforwardjump = "evince %outputfile%#src:%srcfile%:%line%:%column%",
                --textopdfshorterror = "A=%outputfile% ; LOGFILE=\"${A%.pdf}.log\" ; rubber-info \"$LOGFILE\" 2>&1 | head -n 1",
                delay = 100,
                --textopdfviewerlaunch = "qpdfview --unique --instance neovim %outputfile%",
                --textopdfviewerrefresh = "none",
                --textopdfforwardjump = "qpdfview --unique --instance neovim %outputfile%#src:%srcfile%:%line%:%column%",
                --    textopdfshorterror = "A=%outputfile% ; LOGFILE=\"${A%.pdf}.log\" ; rubber-info \"$LOGFILE\" 2>&1 | head -n 1",
            }
            vim.g.knap_settings = gknapsettings
        end,


    }
}
