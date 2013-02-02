function [A, b, c] = sef(A, b, rel, c, obj, pos)

% sef converts any LP of the form "obj cx s.t. Ax rel b"
%   into standard equality form.
% (c) Derek Bennewies
% Last edited Feb 1, 2013
%
% A is the m x n constraint matrix of the LP
% b is the m x 1 constraint values of the LP
% rel is the m x 1 list of relationships between A and b, with entries:
%   "g" for greater than or equal to (>=)
%   "l" for less than or equal to (<=)
%   "e" for equals to (=)
% c is the n x 1 objective coefficients
% obj is either "max" (for maximization) or "min" (for minimization)
% pos is an n x 1 vector with entries "p" for >= 0 constrained vars, and "f" for free vars


%% Useful Variables

m = rows(rel);

%% Multiply coefficients by -1 if min objective

if obj == 'min'
    c = -1 * c;
else
    c = c;
end


%% Convert free variables to positively constrained variables

for i = 1:m

    if pos(i, :) == 'f'
        add_c = c(i) * -1;
        add_col = A(:, i) * -1;
        c = [c; add_c];
        A = [A add_col];
    end
end


%% Convert gte/lte to equality constraints

for i = 1:m

    if rel(i, :) == 'l'
        add_col = eye(m);
        A = [A add_col(:, i)];
        c = [c; 0]

    elseif rel(i, :) == 'g'
        add_col = -1 * eye(m);
        A = [A add_col(:, i)];
        c = [c; 0]

    end

end

end