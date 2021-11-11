{ appimageTools, lib, fetchurl }:

let
  pname = "notion";
  version = "2.0.16-5";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/notion-enhancer/notion-repackaged/releases/download/v${version}/${pname}-${version}.AppImage";
    sha256 = "05lm4lz6bb10zfbbdbmp6wa9jrjb6jygndjkkfkq8fkhv8lznxaz";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/notion-app.desktop \
      $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
 '';

  meta = with lib; {
    description = "Markdown based note-taking software.";
    homepage = "https://www.notion.so/";
    license = licenses.unfree;
    maintainers = with maintainers; [ "schimen" ];
    platforms = [ "x86_64-linux" ];
  };
}

