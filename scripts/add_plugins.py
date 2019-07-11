from __future__ import print_function

import os
import re

new_plugins = ["git", "autojump", "zsh-autosuggestions", "zsh-syntax-highlighting"]

with open(os.path.expanduser('~/.zshrc')) as f:
    s = f.read()

m = re.search('\nplugins=\(([\s\S]*?)\)', s)
if m:
    plugins = set(m.group(1).split())
else:
    plugins = set()

plugins = plugins.union(new_plugins)
plugins_str = '\n  '.join(plugins)
plugins_str = '\nplugins=(\n  ' + plugins_str + '\n)'

s = re.sub('\nplugins=\([\s\S]*?\)', plugins_str, s)

# clear .zshrc
with open(os.path.expanduser('~/.zshrc'), 'w') as f:
    pass

# write new file
with open(os.path.expanduser('~/.zshrc'), 'w') as f:
    f.write(s)
