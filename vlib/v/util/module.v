module util

import os

pub fn mod_path_to_full_name(mod string, path string) ?string {
	vmod_folders := ['vlib', '.vmodules', 'modules']
	path_parts := path.split(os.path_separator)
	mut mod_path := mod.replace('.', os.path_separator)
	mut is_in_vmod := false
	for vmod_folder in vmod_folders {
		if vmod_folder + os.path_separator in path {
			is_in_vmod = true
			break
		}
	}
	for i := path_parts.len - 1; i >= 0; i-- {
		try_path := os.join_path(path_parts[0..i].join(os.path_separator), mod_path)
		if os.is_dir(try_path) {
			if is_in_vmod {
				for j := i; j >= 0; j-- {
					path_part := path_parts[j]
					if path_part in vmod_folders {
						x := try_path.split(os.path_separator)[j + 1..].join('.')
						return x
					}
				}
			} else {
				mut parts2 := try_path.split(os.path_separator)
				mut last_v_mod := -1
				for j := parts2.len; j > 0; j-- {
					p1 := parts2[0..j].join(os.path_separator)
					ls := os.ls(p1) or { []string{} }
					if 'v.mod' in ls {
						last_v_mod = j
					} else {
						break
					}
				}
				if last_v_mod > -1 {
					x := parts2[last_v_mod - 1..].join('.')
					return x
				}
			}
		}
	}
	return error('module not found')
}