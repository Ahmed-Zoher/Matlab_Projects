function B = erlangb(N, A)
% ERLANGB Erlang-B blocking probability of a telecommunications systems
% with n servers (channels) and a traffic intensity a
% where ...
% a is lambda * d.
% lambda is average call arrival rate (call/s).
% d is average call duration (s/call). (note: most textbooks talk in terms of mu = 1/d)
%
% elements of a must be real and positive
% n must be a scalar positive integer. However, n = 0 yields the
% (trival) result of 100% blocking irrespective of traffic intensity.
% Reference: "Telecommunications Networks", by Mischa Schwartz, ISBN 0-201-16423-X
%
% Rule of thumb #1: Subscribers can tolerate a busy hour (i.e. peak) blocking
% probability of no more than 2% (landline) to 5% (mobile)
% example:
% lambda=0:0.0001:0.0065; % mean arrival rate (calls per second)
% d=200; % mean duration (seconds per call)
% a = lambda.*d;
% b = erlangb(4, a); % n=4 channels
% plot(a, b)
% The plot shows 2% blocking occurs at approx a=1.1
% The number of subscribers supported is a / m,
% where m is the busy hour intensity for per subscriber.
%
% Rule of thumb #2:  m = ~20% for land lines and ~4% for mobile
% example: b=0.02, n=4 (==> a=1.1), m=0.05 supports ~22 subscribers
%
% Rule of thumb #3:  Average intensity (~proportional to metered revenue) is
% one fifth of busy hour intensity i.e. 0.2*a.
% In the USA, local loops avg ~60 MOU (minutes of use) per day per subscriber.
% However, usage is increasing with popularity of the Internet.
% In the USA, wireless access avg ~12 MOU per day per subscriber,
% again increasing as the price/min drops.
% SEE ALSO INVERLANGB ("inverse" Erlang B) to calculate intensity for given n and b

% This code is freeware as defined by Free Software Foundation "copyleft" agreement. (C)2000 Colin Warwick
% Comments, bugs, MRs to cwarwick@home.com. Offered "as is". No warranty express or implied.
% version 2000-Sep-10
if (length(N)~=1) | (fix(N) ~= N) | (N < 0)
  error('N must be a scalar positive integer'); 
end
% TODO: test that elements of A are real and positive here?
esum = zeros(size(A));
for ii=0:N
	esum = esum + A .^ ii ./ factorial(ii);
end
B = A .^ N ./ (factorial(N) .* esum);
