## Hyprland Cursor bug reproducing

### Description of bug:

With some cursors configured, eg. `Bibata-Modern-Classic` and `BreezeX-RosePine-Linux` (but not `Vanilla-DMZ` for example),
Some cursors are displayed wrong, eg. a hand instead of a pointer, or vice versa, in chromium apps, like Slack, Discord, 
the chromium browser, etc. This is not the case for apps such as firefox.

#### Good:
![good.png](good.png)

#### Bad:
![bad.png](bad.png)


While testing, I did get a bunch of commits that just resulted in a black screen. It could just be that it doesn't like running inside a VM.

### How it was tested:

Ran `git bisect` with the following commits:
```
good  ->  918d8340afd652b011b937d29d5eea0be08467f5  # latest stable release version
bad  ->  c1afc82a4ceb2e1989ec750b476a97f7f49051e3  # latest commit at time of testing
```

Log of what each commit resulted in:
```
83a5395eaa99fecef777827fff1de486c06b6180 -> black screen on launching (skipped)
5bae7f150b228d3bf677d09fd0c320328b0d0ff0 -> black screen on launching (skipped)
043b859ea2ec8173d8a0f1f90012fcca82275d22 -> black screen on launching (skipped)
8ff9410d2cd39fc1c677799a29f7a063743c0dc9 -> good
4c3b03516209a49244a8f044143c1162752b8a7a -> black screen on launching (skipped)
2da3cfb4220af818b8b44fcc52c9b9b54cbe155e -> black screen on launching (skipped)
55ceca4cdd8f4b3980d2840b85f6b91778a24eab -> bad
33e933e2a020c874037df568d6c033ae20f30bf7 -> black screen on launching (skipped)
76610d9fb0ba5a2d495a963773c38b717d76776f -> bad
928d1dd38a6e4a791d4a4374a4a3bf02311adbb2 -> black screen on launching (skipped)
077494ee85c8fa4c6ae74ad8d749feea826294d2 -> didn't build (skipped)
7f624d2236162db847c70ce1caa12851e77e60eb -> black screen on launching (skipped)
13bc7e1e1415a0b17db609774f59b594c7633941 -> good
511e9ccdd199a90a7378fae1f950de6a315cc406 -> black screen on launching (skipped)
293e687389a19b369f312c5c335c9afe7c886be1 -> good
77b134e23baf769aecdf2ea8ed14d55d00228ce1 -> black screen on launching (skipped)
b16fb9770ca984fb4e0f44e188b0786180afb8ba -> bad
1797319a0785cf9ae4f406d40bc27b032c6f5fb2 -> black screen on launching (skipped)
300228b503b36e5977b0d58713c5b4cf1f07b8a9 -> good
3132f0275e78bdf1a78aee4ccd2944e9e5ba95bd -> black screen on launching (skipped)
efccf25fcc72b416c63ff540703d9f061f39a7f2 -> good
f642fb97df5c69267a03452533de383ff8023570 -> good
d03fa94c2ca1a642959e31adc4fcc2447a3cc623 -> black screen on launching (skipped)
341fb4497fc6b5e6097361c2820a4cd4d1c6ccab -> black screen on launching (skipped)
72bce7efd5b302412f13485af27985965ddf830f -> black screen on launching (skipped)
f17f8b219c699ab52f3d784cad90bdef5bb78188 -> black screen on launching (skipped)
99088eaed806d9268967baf09bc09cdb987c5357 -> black screen on launching (skipped)
e8374e07927826f43d30803b6db00c3b88482e7e -> black screen on launching (skipped)
f7fb7e7e49e3b47f9b72c55fbf2d093e1a7981f5 -> black screen on launching (skipped)
672bf1f8670b200da57e2f6de4e9ed7efd8c98fc -> black screen on launching (skipped)
e2efecc24e6534f46352cab13975778e3f0b5735 -> black screen on launching (skipped)
5979ceb56b165ee35809a0eeda5f4be1aedbb7b6 -> black screen on launching (skipped)
faa157e1626fb56b5f01ac0597518cc41bf1c40b -> black screen on launching (skipped)
7c68236a51291e71db04233d04eae65f4ebd594f -> black screen on launching (skipped)
8a4548e4302b1cc00fca368a7cc2e3171516420c -> black screen on launching (skipped)
87db950189d87eb00d01b9df9959b36ba0f4d5c7 -> black screen on launching (skipped)
a5f58a31268da95e36c0918ac75589c05e81b892 -> black screen on launching (skipped)
cbaac6deafb857662d630efbca8b0ebac0f11b44 -> black screen on launching (skipped)
efcbcd7297e2c9b06e3cd5d3296d47504f502cee -> black screen on launching (skipped)
3b6bcd6ddcfebd1fed0694aa2c0bd9753f4d5d46 -> black screen on launching (skipped)
db1f5cd13732bc440b8e5e353d87cdf7faaf1872 -> black screen on launching (skipped)
3c758db95c129ed6ca7ce0c1b5b82ad6e189488d -> black screen on launching (skipped)
fe1975488725c006f4dc4575c1eb1df84ed1a893 -> black screen on launching (skipped)
752604cfe954bd96bd6b5aca3e80dafb6a426cfb -> black screen on launching (skipped)
cf373d315e9fb060576ed407bd5ee2dfb8a6d2e2 -> black screen on launching (skipped)
e6fc9873b5e10e7ac00085da7d599776ed72f297 -> black screen on launching (skipped)
016da234d0e852de3ef20eb2e89ac58d2a85f6e7 -> black screen on launching (skipped)
f2b6ebbf5427c319c7b3c9621a98751598b360f9 -> black screen on launching (skipped)
```

`Git bisect` result:
```
There are only 'skip'ped commits left to test.
The first bad commit could be any of:
d03fa94c2ca1a642959e31adc4fcc2447a3cc623
511e9ccdd199a90a7378fae1f950de6a315cc406
83a5395eaa99fecef777827fff1de486c06b6180
3132f0275e78bdf1a78aee4ccd2944e9e5ba95bd
5bae7f150b228d3bf677d09fd0c320328b0d0ff0
1797319a0785cf9ae4f406d40bc27b032c6f5fb2
87db950189d87eb00d01b9df9959b36ba0f4d5c7
5979ceb56b165ee35809a0eeda5f4be1aedbb7b6
77b134e23baf769aecdf2ea8ed14d55d00228ce1
672bf1f8670b200da57e2f6de4e9ed7efd8c98fc
e8374e07927826f43d30803b6db00c3b88482e7e
33e933e2a020c874037df568d6c033ae20f30bf7
f17f8b219c699ab52f3d784cad90bdef5bb78188
341fb4497fc6b5e6097361c2820a4cd4d1c6ccab
4c3b03516209a49244a8f044143c1162752b8a7a
7c68236a51291e71db04233d04eae65f4ebd594f
cbaac6deafb857662d630efbca8b0ebac0f11b44
3b6bcd6ddcfebd1fed0694aa2c0bd9753f4d5d46
3c758db95c129ed6ca7ce0c1b5b82ad6e189488d
752604cfe954bd96bd6b5aca3e80dafb6a426cfb
e6fc9873b5e10e7ac00085da7d599776ed72f297
077494ee85c8fa4c6ae74ad8d749feea826294d2
db1f5cd13732bc440b8e5e353d87cdf7faaf1872
928d1dd38a6e4a791d4a4374a4a3bf02311adbb2
a5f58a31268da95e36c0918ac75589c05e81b892
8a4548e4302b1cc00fca368a7cc2e3171516420c
faa157e1626fb56b5f01ac0597518cc41bf1c40b
7f624d2236162db847c70ce1caa12851e77e60eb
e2efecc24e6534f46352cab13975778e3f0b5735
2da3cfb4220af818b8b44fcc52c9b9b54cbe155e
f7fb7e7e49e3b47f9b72c55fbf2d093e1a7981f5
99088eaed806d9268967baf09bc09cdb987c5357
efcbcd7297e2c9b06e3cd5d3296d47504f502cee
043b859ea2ec8173d8a0f1f90012fcca82275d22
72bce7efd5b302412f13485af27985965ddf830f
cf373d315e9fb060576ed407bd5ee2dfb8a6d2e2
fe1975488725c006f4dc4575c1eb1df84ed1a893
016da234d0e852de3ef20eb2e89ac58d2a85f6e7
f2b6ebbf5427c319c7b3c9621a98751598b360f9
b16fb9770ca984fb4e0f44e188b0786180afb8ba
We cannot bisect more!
```

### Test out yourself:

Change the `rev` of the `hyprland.url` input, and run:

```
nix build .#nixosConfigurations.vm.config.system.build.vm --impure && ./result/bin/run-*-vm
```

Autologin is configured, and `chromium` will launch at startup

The `$mod` key is `Control_L`, `$mod+f` opens `chromium`, `$mod+Return` opens `kitty`, `$mod+Space` opens `rofi`
