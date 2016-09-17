function extraNodesCell = extraNodes(saved,structstate)
% each row an extra node on branch indicated by onBranch
% origin gives the closes child stemming off from branch
% columns:  bID origin XYZ F


if structstate==1
    extra=saved.datastruct.extrapoints{1};
elseif structstate==2
    extra=saved.datastruct.extrapoints{2};
end

% create cell array where dim 2 and 3 are included in a single cell
F=num2cell(extra.responses.off.F,[2,3]);
F=cellfun(@squeeze,F,'UniformOutput',false);

% creates row cell array, each element a 3x1 matrix XYZ coordinate 
extraXYZ=num2cell(extra.XYZ',2);
extraXYZ=cellfun(@transp,extraXYZ,'UniformOutput',false);

% return struct array
extraNodesCell=[num2cell(extra.branchnum'), extra.origin', extraXYZ, F];

end


