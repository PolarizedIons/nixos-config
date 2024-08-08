source $stdenv/setup
PATH=$dpkg/bin:$PATH

runHook preInstall
dpkg -x $src unpacked
echo unpacked: $(ls unpacked)
echo out: $out
mkdir -p $out
cp -r unpacked/* $out/

patchelf --set-interpreter "${dynamicLinker}" \
    --set-rpath "$ORIGIN:$rpath" $out/opt/awsvpnclient/AWS\ VPN\ Client
find $out -type f -name "*.so" -exec \
    patchelf --set-rpath "$ORIGIN:$rpath" {} ';'    

runHook postInstall