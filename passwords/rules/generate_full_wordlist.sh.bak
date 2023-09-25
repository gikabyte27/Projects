#!/bin/bash


echo "PASSWORD GENERATOR"
echo 
echo
echo "-------------------------------------"

if [ $# -eq 0 ]; then
	echo "Usage: $0 <seed_file>"
	exit 1
fi

RULE_LEETSPEAK=/opt/Projects/passwords/rules/leetspeak.rule
RULE_PREPROCESS=/opt/Projects/passwords/rules/preprocess.rule
RULE_NUMBERS_YEARS=/opt/Projects/passwords/rules/add_numbers_and_years.rule
RULE_SPECIALS=/opt/Projects/passwords/rules/add_specials.rule
RULE_SIMPLE_NUMBERS_YEARS=/opt/Projects/passwords/rules/simple_add_numbers_and_years.rule
RULE_SIMPLE_SPECIALS=/opt/Projects/passwords/rules/simple_add_specials.rule

#Initialize variables with default values
leet_flag=true
simple_flag=true
full_flag=false
none_flag=false

INTERIM_OUTPUT=$1
OUTPUT=wordlist.txt

# Prompt the user if they want to enable --leet
read -p "Do you want to enable leet? (Y/n): " leet_response
leet_flag=true
if [ "$leet_response" = "n" ]; then
  leet_flag=false
fi

# Prompt the user whether they want simple or full
  read -p "Do you want to enable simple, full or no additional rules? (simple/full/none): " mode_response
  case $mode_response in
    "simple")
      simple_flag=true
      full_flag=false
      ;;
    "full")
      full_flag=true
      simple_flag=false
      ;;
    "none")
      full_flag=false
      simple_flag=false
      none_flag=true
      ;;
    *)
      echo "Defaulting to --simple."
      simple_flag=true
      ;;
  esac


# Check individual options and perform actions
if [ "$leet_flag" = true ]; then
  INTERIM_OUTPUT=leet_sorted_$1.txt
  echo "Step 1: Performing --leet"
  hashcat $1 --rules $RULE_LEETSPEAK --stdout | sort | uniq > $INTERIM_OUTPUT
  # Perform actions for --leet
fi

if [ "$simple_flag" = true ]; then
  echo "Step 2: Performing --simple"
  # Perform actions for --simple
  hashcat $INTERIM_OUTPUT --rules $RULE_SIMPLE_NUMBERS_YEARS --rules $RULE_SIMPLE_SPECIALS --stdout | sort | uniq > $OUTPUT
fi

if [ "$full_flag" = true ]; then
  echo "Step 2: Performing --full"
  # Perform actions for --full
  hashcat $INTERIM_OUTPUT --rules $RULE_PREPROCESS --rules $RULE_NUMBERS_YEARS --rules $RULE_SPECIALS --stdout | sort | uniq > $OUTPUT
fi

if [ "$none_flag" = true ]; then
  exit 0
fi

echo "Wordlist generated!"
wc -l $OUTPUT
rm -rf $INTERIM_OUTPUT

# Process non-option arguments (if any)
shift $((OPTIND-1))

# Handle non-option arguments (if any)
if [ $# -gt 0 ]; then
  echo "Non-option arguments:"
  for arg in "$@"; do
    echo "$arg"
    # Perform actions on non-option arguments
  done
fi
