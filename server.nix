{ stdenv
, openjdk11
, unzip
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name    = "xmage_server";
  version = "1.4.49";

  src = fetchFromGitHub {
    owner = "timhae";
    repo = "mage";
    rev = "d3f0eb12314124d9dd47c0513efae00b3f8d950f";
    sha256 = "";
  };

  preferLocalBuild = true;

  unpackPhase = ''
    ${unzip}/bin/unzip ${src}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/extension $out/plugins
    cp -rv ./* $out

    cat << EOF > $out/bin/xmage_server
#!/usr/bin/env bash
    exec ${openjdk11}/bin/java -Xms1g -Xmx4g -jar \
    -Dfile.encoding=UTF-8 \
    -Djava.security.policy=$out/config/security.policy \
    -Dlog4j.configuration=file:$out/config/log4j.properties \
    -Dconfig-path=$out/config/config.xml \
    -Dplugin-path=$out/plugins/ \
    -Dextension-path=$out/extension/ \
    -Dmessage-path=$out/ \
    -jar $out/lib/mage-server-${version}.jar
    echo "start xmage server"
EOF

    chmod +x $out/bin/xmage_server
  '';

  meta = with stdenv.lib; {
    description = "Magic Another Game Engine server";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    homepage = "http://xmage.de/";
  };

}

