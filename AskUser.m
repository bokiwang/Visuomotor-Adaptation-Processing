function [modechoice] = AskUser()
% GUI menu asking for user input 
% 
% Peiyuan (Boki) Wang
    fig = gcf;
    existingmenus = findall( fig, 'Type', 'uimenu' );
    arrayfun(@(x) delete(x), existingmenus);
    m = uimenu(fig, 'Text', 'Visual Inspection');
    mitem1 = uimenu(m,'Text','Change', 'MenuSelectedFcn',@Change_callback);
    mitem2 = uimenu(m, 'Text', 'Done', 'MenuSelectedFcn',@Done_callback);
    modechoice = 'Change';
end

function Change_callback(fig,KeyPressFcn)
    modechoice = 'Change';
end

function Done_callback(fig, KeyPressFcn)
    modechoice = 'Done';
    to_exit = 1;
end