{ fetchFromGitHub }:
let
  repo = fetchFromGitHub {
    owner = "vlaci";
    repo = "openconnect-sso";
    rev = "94128073ef49acb3bad84a2ae19fdef926ab7bdf";
    sha256 = "JFVvTw11KFnrd/A5z3QCh30ac9MZG+ojDY3udAFpmCE=";
  };

in
(import "${repo}/nix" {}).openconnect-sso
