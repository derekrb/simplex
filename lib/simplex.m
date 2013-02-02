function [x, z] = simplex(A, b, rel, c, obj, pos, basis, N)

% simplex finds the optimum of an LP using the simplex algorithm
% (c) Derek Bennewies
% Last edited Feb 2, 2013
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
% basis is a basis of the initial problem following conversion (hmm need to fix this)
% N is a vector containing the complement of the initial basis
%
% x is a vector containing the optimal values of variables x
% res is the optimum value of the objective function


%% Useful Variables
m = rows(A);
nbas = rows(N);
stop_flag = 0;


%% Convert the LP into SEF
[A, b, c] = sef(A, b, rel, c, obj, pos);
n = rows(c);
x = zeros(n, 1);
z = 0;


%% Simplex algorithm

while true

    % Convert to canonical form
    [A, b, c, z] = canon(A, b, c, basis, z);

    % Select pivot variable

    [kval, k] = max(c)

    k = 0;
    for i = 1:nbas
        if c(N(i)) > 0
            k = N(i)
        end
    end

    % Break if solution is optimal
    if kval = 0
        disp('Optimal solution reached!')
        return
    end

    % Find the nonbasis variable to change
    x_poss = b ./ A(:, k);
    x_min = max(max(x_poss));
    for i = 1:m
        if x_poss(i) > 0 & x_poss(i) < x_min
            x_min = x_poss(i);
            l = basis(i);
        end
    end

    % Break if system is unbounded
    if x_min == 0
        disp('System is unbounded!')
        return
    end

    % Update the solution x
    x(basis) = b - x_min * A(:, k);
    x(k) = x_min;

    % Update the basis and complement
    basis(find(basis==l)) = k;
    N(find(N==k)) = l;

end

end
