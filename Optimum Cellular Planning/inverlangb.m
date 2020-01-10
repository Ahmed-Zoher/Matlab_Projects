function A = inverlangb(N, B)
% INVERLANGB inverse Erlang-B. Newton-Raphson iteration of traffic intensity
% A is the traffic intensity in Erlangs
% B is the blocking probability
% N is the number of channels (must be a positive integer)
% Example:
% a = [];
% b = 0.04
% n=1:12
% for ii=n(1):n(12)
%	a(ii) = inverlangb(ii, b); % inverlangb not vectorized in this release
% end
% plot(n, a)
%
% see also ERLANGB ERLANGBPRIME
% References: Erlang: "Telecommunications Networks", by Mischa Schwartz, ISBN 0-201-16423-X
% Newton-Raphson: "Advanced Engineering Mathematics", by Erwin Kreyszig, ISBN 0-471-55380-8


% This code is freeware as defined by Free Software Foundation "copyleft" agreement. (C)2000 Colin Warwick
% Comments, bugs, MRs to cwarwick@home.com. Offered "as is". No warranty express or implied
% version 2000-Sep-10
if (length(N)~=1) | (fix(N) ~= N) | (N < 0)
  error('N must be a scalar positive integer'); 
end
if (length(B)~=1) | (B < 0)
  error('B must be a scalar & positive'); 
end
% TODO: It would be neat to vectorize with respect to N or B (e.g. for plots)
if (B == 0) | (N == 0)
	A = 0; % weed out some trival, but awkward, cases
else
    An=N; %initial guess (aim high)
    fn=erlangb(N, An)-B;
    for ii=1:1000
        fprimen = erlangbprime(N, An);
        if fprimen == 0
            error('fprimen == 0')
        end
        Anplus1 = An - fn/fprimen;
        if abs(Anplus1-An) < eps*10
            break
        end
			if Anplus1 > 0
        		An=Anplus1; % don't allow An to go negative
			else
				An=N*rand(1,1); %try another guess
			end
        fn=erlangb(N, An)-B;
        if ii == 1000
            error('no convergence in 1000 loops')
        end
    end
    A=Anplus1;
end