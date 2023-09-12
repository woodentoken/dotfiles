inc=()
while IFS= read -r -d $'\0'; do
	inc+=("$REPLY")
done < <(find . -maxdepth 2 -type f,d -print0)

exi=()
while IFS= read -r -d $'\0'; do
	exi+=("$REPLY")
done < <(find ../.* -maxdepth 0 -type f,d -print0)

# basenameify existing dotfiles
for i in "${!exi[@]}"; do
	exi[$i]=$(basename ${exi[$i]})
done

# basenameify incoming dotfiles
for i in "${!inc[@]}"; do
	inc[$i]=$(basename ${inc[$i]})
done

# compute the intersection of the basenamed files
common_dotfiles=($(comm -12 <(printf '%s\n' "${inc[@]}" | sort) <(printf '%s\n' "${exi[@]}" | sort)))
