from __future__ import print_function

import os
import re
import sys


print("Modifying ~/.zshrc...")

with open(os.path.expanduser('~/.zshrc')) as f:
    s = f.read()

# change theme
s = re.sub(r'\nZSH_THEME=".*"', r'\nZSH_THEME="agnoster"', s)
print("Changed theme to agnoster")

# add plugins
new_plugins = ["git", "autojump", "zsh-autosuggestions", "fast-syntax-highlighting"]

m = re.search('\nplugins=\(([\s\S]*?)\)', s)
if m:
    plugins = set(m.group(1).split())
else:
    plugins = set()

plugins = plugins.union(new_plugins)
plugins_str = '\n  '.join(plugins)
plugins_str = '\nplugins=(\n  ' + plugins_str + '\n)'

s = re.sub('\nplugins=\([\s\S]*?\)', plugins_str, s)
print("Changed plugins to {}".format(plugins))

# add DEFAULT_USER
if not re.findall('\nexport DEFAULT_USER=.*', s):
    s += "\n# default user to hide agnoster prompt" \
         "\nexport DEFAULT_USER={}\n".format(sys.argv[1])
    print("Added DEFAULT_USER={}".format(sys.arv[1]))

print("Writing to ~/.zshrc...")
# clear .zshrc
with open(os.path.expanduser('~/.zshrc'), 'w') as f:
    pass

# write new file
with open(os.path.expanduser('~/.zshrc'), 'w') as f:
    f.write(s)
