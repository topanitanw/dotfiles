#!/bin/bash

# Function to reopen all currently opened Perforce files to a specific changelist
# Usage: p8_reopen_to_cl <changelist_number>
function p8_reopen_to_cl() {
    local clno=$1

    # Check if changelist number is provided
    if [ -z "$clno" ]; then
        echo "Error: Changelist number is required"
        echo "Usage: p8_reopen_to_cl <changelist_number>"
        return 1
    fi

    # Check if changelist number is numeric
    if ! [[ "$clno" =~ ^[0-9]+$ ]]; then
        echo "Error: Changelist number must be numeric"
        return 1
    fi

    # Get list of opened files
    local opened_files;
    opened_files=$(p4 opened 2>/dev/null | cut -d "#" -f 1 | cut -d " " -f 1)

    # Check if p4 command was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to get opened files from Perforce"
        return 1
    fi

    # Check if there are any opened files
    if [ -z "$opened_files" ]; then
        echo "No files are currently opened"
        return 0
    fi

    # Count files
    local file_count;
    file_count=$(echo "$opened_files" | wc -l)

    echo "Found $file_count opened file(s)"
    echo "Reopening files to changelist $clno..."

    # Reopen each file to the specified changelist
    local success_count;
    local fail_count;
    success_count=0
    fail_count=0

    while IFS= read -r file; do
        if [ -n "$file" ]; then
            if p4 reopen -c "$clno" "$file" 2>/dev/null; then
                echo "  ✓ $file"
                ((success_count++))
            else
                echo "  ✗ Failed: $file"
                ((fail_count++))
            fi
        fi
    done <<< "$opened_files"

    # Summary
    echo ""
    echo "Summary: $success_count succeeded, $fail_count failed"

    if [ $fail_count -gt 0 ]; then
        return 1
    fi

    return 0
}

# Function to set P4ROOT environment variable from p4 info
# Usage: p8_set_root
function p8_set_root() {
    # Check if p4 is available
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    # Get p4 info output
    local p8_info_output;
    p8_info_output=$(p4 info 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "Error: Failed to get p4 info"
        return 1
    fi

    # Extract Client root for P4ROOT
    local client_root;
    client_root=$(echo "$p8_info_output" | grep "^Client root:" | cut -d ":" -f 2- | sed 's/^[[:space:]]*//')

    # Check if value was found
    if [ -z "$client_root" ]; then
        echo "Error: Could not extract Client root from p4 info"
        return 1
    fi

    # Export the environment variable
    export P4ROOT="$client_root"

    # Print confirmation
    echo "P4ROOT = $P4ROOT"

    return 0
}

# Function to set P4CLIENT environment variable from p4 info
# Usage: p8_set_client
function p8_set_client() {
    # Check if p4 is available
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    # Get p4 info output
    local p8_info_output;
    p8_info_output=$(p4 info 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "Error: Failed to get p4 info"
        return 1
    fi

    # Extract Client name for P4CLIENT
    local client_name=$(echo "$p8_info_output" | grep "^Client name:" | cut -d ":" -f 2- | sed 's/^[[:space:]]*//')

    # Check if value was found
    if [ -z "$client_name" ]; then
        echo "Error: Could not extract Client name from p4 info"
        return 1
    fi

    # Export the environment variable
    export P4CLIENT="$client_name"

    # Print confirmation
    echo "P4CLIENT = $P4CLIENT"

    return 0
}

# Function to set up both P4ROOT and P4CLIENT environment variables from p4 info
# Usage: p8_setup_env
function p8_setup_env() {
    echo "Setting up P4 environment variables..."

    # Set P4ROOT
    if ! p8_set_root; then
        return 1
    fi

    # Set P4CLIENT
    if ! p8_set_client; then
        return 1
    fi

    return 0
}

# Function to output absolute paths to all opened files
# Usage: p8_open_path
function p8_open_path() {
    # Check if p4 is available
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    # Get list of opened files with their depot paths
    # p4 opened output format: //depot/path/file.txt#1 - edit change 12345 (text)
    local opened_output=$(p4 opened 2>/dev/null)

    # Check if p4 command was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to get opened files from Perforce"
        return 1
    fi

    # Check if there are any opened files
    if [ -z "$opened_output" ]; then
        echo "No files are currently opened"
        return 0
    fi

    # Extract depot paths from p4 opened output (everything before the first #)
    local depot_paths=$(echo "$opened_output" | cut -d "#" -f 1)

    # Convert depot paths to absolute local paths using p4 where
    while IFS= read -r depot_path; do
        # If depot path is empty, continue to next iteration
        if [ -z "$depot_path" ]; then
            continue
        fi

        # Use p4 where to get the local absolute path
        # p4 where output format: //depot/path/file.txt //client/path/file.txt /absolute/local/path/file.txt
        local where_output=$(p4 where "$depot_path" 2>/dev/null)
        local where_exit_code=$?

        # If p4 where command failed (non-zero exit), terminate
        if [ $where_exit_code -ne 0 ]; then
            echo "Error: p4 where command failed for $depot_path (exit code: $where_exit_code)" >&2
            return 1
        fi

        # If where output is empty, terminate
        if [ -z "$where_output" ]; then
            echo "Error: p4 where returned empty output for $depot_path" >&2
            return 1
        fi

        # Extract the local path (third field in p4 where output)
        local local_path=$(echo "$where_output" | awk '{print $3}')
        # If local path extraction failed, continue to next iteration
        if [ -z "$local_path" ]; then
            echo "Warning: Could not extract local path for $depot_path, skipping" >&2
            continue
        fi

        # Successfully extracted local path, output it
        echo "$local_path"
    done <<< "$depot_paths"

    return 0
}

# Function to set p8_cl environment variable from currently opened files
# Extracts unique changelist numbers from p4 opened output
# Usage: p8_set_cl
function p8_set_cl() {
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    local opened_output
    opened_output=$(p4 opened 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "Error: Failed to get opened files from Perforce"
        return 1
    fi

    if [ -z "$opened_output" ]; then
        unset p8_cl
        echo "p8_cl = <not set> (no files currently opened)"
        return 0
    fi

    local changelists
    changelists=$(echo "$opened_output" | grep -o 'change [0-9]*' | cut -d' ' -f2 | sort -u)

    if [ -n "$changelists" ]; then
        export p8_cl=$(echo "$changelists" | tr '\n' ' ' | sed 's/ $//')
        echo "p8_cl = $p8_cl"
    else
        unset p8_cl
        echo "p8_cl = <not set> (no changelist found)"
    fi

    return 0
}

# Function to display all exported p8_* shell variables
# Usage: p8_env
function p8_env() {
    echo "--------------------------------"
    echo "🔧 P8 VARIABLES:"
    echo "--------------------------------"

    local found=0

    while IFS= read -r varname; do
        if [ -n "$varname" ]; then
            echo "${varname} = ${!varname}"
            ((found++))
        fi
    done < <(compgen -v p8_)

    if [ "$found" -eq 0 ]; then
        echo "No p8_* variables are currently set."
    else
        echo
        echo "Total: $found variable(s)"
    fi

    return 0
}

# List compact changelists with descriptions capped at 50 characters.
function p8_list_changes() {
    p4 changes -L -u "${P4USER}" -c "${P4CLIENT}" -s "$1" |
        awk -v width=50 '
            function emit() {
                printf "cl: %s on %s in %s %s %c%s%c\n", change, date, client, status, 39, substr(desc, 1, width), 39
            }

            /^Change / {
                if (change) emit()
                change = $2
                date = $4
                client = $6
                sub(/^[^@]*@/, "", client)
                status = $7
                desc = ""
                next
            }

            {
                gsub(/^[[:space:]]+|[[:space:]]+$/, "")
                if ($0 != "" && length(desc) < width)
                    desc = desc (desc ? " " : "") $0
            }

            END { if (change) emit() }
        '
}

# Function to display comprehensive Perforce status information
# Shows p4 info, p4 opened, P4 environment variables, and current opened changelist
# Usage: p8_status
function p8_status() {
    # Check if p4 is available
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    echo "=========================================="
    echo "           PERFORCE STATUS"
    echo "=========================================="
    echo

    # Display P4 Info
    echo "--------------------------------"
    echo "📋 P4 INFO:"
    echo "--------------------------------"
    local p4_info_output=$(p4 info 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$p4_info_output" ]; then
        echo "$p4_info_output"
    else
        echo "❌ Failed to get p4 info or no connection to Perforce server"
        return 1
    fi
    echo

    # Display P4 Environment Variables
    echo "--------------------------------"
    echo "🌍 P4 ENVIRONMENT VARIABLES:"
    echo "--------------------------------"
    echo "P4CONFIG = ${P4CONFIG:-<not set>}"
    echo "P4EDITOR = ${P4EDITOR:-<not set>}"
    echo "P4DIFF = ${P4DIFF:-<not set>}"
    echo "P4ROOT = ${P4ROOT:-<not set>}"
    echo "P4USER = ${P4USER:-<not set>}"
    echo "P4CLIENT = ${P4CLIENT:-<not set>}"
    echo "P4PORT = ${P4PORT:-<not set>}"
    echo

    # Display P4 Opened Files
    echo "--------------------------------"
    echo "📂 OPENED FILES:"
    echo "--------------------------------"
    local opened_output;
    opened_output=$(p4 opened 2>/dev/null)
    if [ $? -eq 0 ]; then
        if [ -n "$opened_output" ]; then
            echo "$opened_output"
            echo
            # Count opened files
            local file_count;
            file_count=$(echo "$opened_output" | wc -l | tr -d ' ')
            echo "Total opened files: $file_count"
        else
            echo "No files are currently opened"
        fi
    else
        echo "❌ Failed to get opened files"
    fi
    echo

    # Display Current Opened Changelist(s)
    echo "--------------------------------"
    echo "📝 CURRENT OPENED CHANGELIST(s):"
    echo "--------------------------------"
    if [ -n "$opened_output" ]; then
        # Extract unique changelist numbers from opened files
        # Format: //depot/path#1 - edit change 12345 (text)
        local changelists;
        changelists=$(echo "$opened_output" | grep -o 'change [0-9]*' | cut -d' ' -f2 | sort -u)

        if [ -n "$changelists" ]; then
            while IFS= read -r cl; do
                if [ -n "$cl" ]; then
                    if [ "$cl" = "default" ]; then
                        echo "🔄 Default changelist"
                    else
                        echo "🔢 Changelist: $cl"
                        # Get changelist description
                        local cl_desc
                        cl_desc=$(p4 describe -s "$cl" 2>/dev/null | head -n 10)
                        if [ $? -eq 0 ] && [ -n "$cl_desc" ]; then
                            echo "   Description:"
                            echo "$cl_desc" | sed 's/^/   /'
                        fi
                    fi
                    echo
                fi
            done <<< "$changelists"
        else
            echo "No changelist information found"
        fi
    else
        echo "No opened files to check for changelists"
    fi
    echo

    p8_set_cl
    echo

    echo "--------------------------------"
    echo "📝 PENDING CHANGELISTS:"
    echo "--------------------------------"
    p8_list_changes pending
    echo

    echo "--------------------------------"
    echo "📝 SHELVED CHANGELISTS:"
    echo "--------------------------------"
    p8_list_changes shelved
    echo

    p8_env
    echo

    echo "=========================================="
    return 0
}

# Function to convert a Perforce depot path to absolute local filesystem path
# Usage: p8_abs_path <depot_path>
# Example: p8_abs_path "///sw/mods/rel/dcdiag/r8/contrib/fieldiag"
function p8_abs_path() {
    local depot_path="$1"

    # Check if depot path argument is provided
    if [ -z "$depot_path" ]; then
        echo "Error: Depot path is required"
        echo "Usage: p8_abs_path <depot_path>"
        echo "Example: p8_abs_path \"///sw/mods/rel/dcdiag/r8/contrib/fieldiag\""
        return 1
    fi

    # Check if p4 is available
    if ! command -v p4 &> /dev/null; then
        echo "Error: p4 command not found"
        return 1
    fi

    # Normalize the depot path - ensure it starts with //
    if [[ "$depot_path" =~ ^///.*$ ]]; then
        # Convert triple slash to double slash (normalize depot path format)
        depot_path="//${depot_path#///}"
    elif [[ ! "$depot_path" =~ ^//.*$ ]]; then
        # Add // prefix if not present
        depot_path="//$depot_path"
    fi

    # Use p4 where to get the local absolute path
    # p4 where output format: //depot/path //client/path /absolute/local/path
    local where_output
    where_output=$(p4 where "$depot_path" 2>/dev/null)
    local where_exit_code=$?

    # Check if p4 where command failed
    if [ $where_exit_code -ne 0 ]; then
        echo "Error: p4 where command failed for '$depot_path' (exit code: $where_exit_code)" >&2
        echo "This could mean:"
        echo "  - The depot path doesn't exist in your client view"
        echo "  - You're not connected to the Perforce server"
        echo "  - The path is not mapped in your workspace"
        return 1
    fi

    # Check if where output is empty
    if [ -z "$where_output" ]; then
        echo "Error: p4 where returned empty output for '$depot_path'" >&2
        echo "The depot path may not be mapped in your current client workspace"
        return 1
    fi

    # Extract the local path (third field in p4 where output)
    local local_path
    local_path=$(echo "$where_output" | awk '{print $3}')

    # Validate that we successfully extracted a local path
    if [ -z "$local_path" ]; then
        echo "Error: Could not extract local path from p4 where output" >&2
        echo "p4 where output was: $where_output" >&2
        return 1
    fi

    # Output the absolute local path
    echo "$local_path"
    return 0
}

# Create an empty integration changelist using hm-style description filtering.
# Usage: p8_create_integration_cl <source_cl> <from_branch> <to_branch> [generic_bug]
p8_create_integration_cl()
{
    local source_cl=$1
    local from_branch=$2
    local to_branch=$3
    local generic_bug=${4:-}
    local output
    local new_cl

    if ! output=$(
        {
            echo "Change: new"
            echo "Status: new"
            echo "Description:"

            p4 describe -s "$source_cl" |
                sed '1,/^$/d
                     /PRESUBMIT_TESTING/d
                     /https\?:\/\/ausdvs\.nvidia/d
                     /https\?:\/\/AUSDVS\.nvidia/d
                     /https\?:\/\/builds4u/d
                     /https\?:\/\/testbot\.nvidia/d
                     /skip_.vs_virtual_check/d
                     /#review/d
                     /AS2 Bundle ID/d
                     /nvp4review\.p4review.*p4r/d
                     /^[[:space:]]*\(Approved Bug\|Generic bug\)/d
                     /^[^[:space:]]/,$d' |
                sed 's/^[[:space:]]//' |
                awk -v prefix="(I ${from_branch}->${to_branch}) " '
                    # Prefix the copied title with the integration route.
                    NR == 1 { $0 = prefix $0 }
                    { print "\t" $0 }
                '

            printf '\t\n'
            printf '\t%s\n' \
                "$(p4 describe -s "$source_cl" | head -n 1)"
            printf '\tIntegrated from %s to %s\n' \
                "$from_branch" "$to_branch"

            if [[ -n "$generic_bug" ]]; then
                printf '\tGeneric bug %s\n' "$generic_bug"
            fi
        } | p4 change -i
    ); then
        return 1
    fi

    new_cl=$(
        printf '%s\n' "$output" |
            sed -n 's/^Change \([0-9][0-9]*\) created\.$/\1/p'
    )

    if [[ -z "$new_cl" ]]; then
        echo "ERROR: unable to extract new CL number from:" >&2
        echo "$output" >&2
        return 1
    fi

    printf '%s\n' "$new_cl"
}

# Submit or resubmit any CL to DVS and automatically record its latest result URL.
# Use this instead of manually running "hm test dvs", copying its URL, and editing the CL.
# DVS options: axl, rm, mods/pvs, or any quoted raw keyword; DVS_BUILD_ALL is always included.
# Example: p8_test_dvs 38890209 mods axl
# Usage: p8_test_dvs <changelist> [axl|rm|mods|pvs|"DVS keyword" ...]
p8_test_dvs()
{
    # Show the supported DVS shortcuts without submitting a test.
    if [[ ${1:-} = -h || ${1:-} = --help ]]; then
        printf '%s\n' \
            'Usage: p8_test_dvs <changelist> [DVS option ...]' \
            'DVS options (DVS_BUILD_ALL is always included):' \
            '  axl       DVS_AXL_SANITY all' \
            '  rm        DVS_RM_SANITY all' \
            '  mods|pvs  DVS_MODS_SANITY all + DVS_Extended-Mods_SANITY all' \
            '  "..."     Pass a quoted raw DVS keyword unchanged'
        return 0
    fi

    # Validate the changelist before invoking hm.
    if [[ $# -lt 1 || ! $1 =~ ^[0-9]+$ ]]; then
        echo 'Usage: p8_test_dvs <changelist> [axl|rm|mods|pvs|"DVS keyword" ...]' >&2
        echo 'DVS_BUILD_ALL is always included; use --help for option details.' >&2
        return 2
    fi

    # Keep the changelist while forwarding every optional DVS argument to hm.
    local changelist=$1
    local output virtual_id dvs_url
    shift

    # Submit the requested changelist to DVS and preserve hm output for recovery.
    if ! output=$(hm test dvs "$changelist" "$@" 2>&1); then
        printf '%s\n' "$output" >&2
        return 1
    fi
    printf '%s\n' "$output"

    # Extract the virtual ID from either query-string or path-style DVS output.
    if [[ $output =~ virtualId[=/]([0-9]+) ]]; then
        virtual_id=${BASH_REMATCH[1]}
    else
        echo "ERROR: DVS submitted for CL $changelist, but virtualId was not found" >&2
        return 1
    fi

    # Build the canonical link used by the Pre-submit testing field.
    dvs_url="http://builds4u.nvidia.com/dvs/#/change/dvs/virtualId/${virtual_id}?showTab=DVS"

    # Replace duplicate links or append the first link inside the Description field.
    if ! p4 change -o "$changelist" |
        awk -v dvs_line="\tPre-submit testing: $dvs_url" '
            # Enter the changelist Description field.
            /^Description:/ {
                in_description = 1
                print
                next
            }

            # Replace the first link and remove any duplicate links.
            in_description && /^\t[[:space:]]*Pre-submit testing:/ {
                if (!link_written) {
                    print dvs_line
                    link_written = 1
                }
                next
            }

            # Append the link before the next changelist-spec field when absent.
            in_description && /^[A-Z][A-Za-z]*:/ {
                if (!link_written) {
                    print dvs_line
                    print ""
                    link_written = 1
                }
                in_description = 0
            }

            # Preserve every changelist-spec line not handled above.
            { print }
        ' |
        p4 change -i -u >/dev/null
    then
        echo "ERROR: DVS submitted, but CL $changelist could not be updated" >&2
        echo "Pre-submit testing: $dvs_url" >&2
        return 1
    fi

    # Report the recorded DVS result.
    echo "CL $changelist updated: $dvs_url"
}

# Integrate a submitted CL through hm, label its route, submit DVS, and record the result URL.
# Use this when promoting one CL between branches without manually creating or editing a new CL.
# DVS options are the same as p8_test_dvs and are forwarded unchanged after the branch arguments.
# Example: p8_integrate_cl 38889995 r570 r575 mods
# Usage: p8_integrate_cl <source_cl> <from_branch> <to_branch> [DVS options ...]
p8_integrate_cl()
{
    # Show integration usage together with the available DVS shortcuts.
    if [[ ${1:-} = -h || ${1:-} = --help ]]; then
        echo 'Usage: p8_integrate_cl <source_cl> <from_branch> <to_branch> [DVS options ...]'
        p8_test_dvs --help | sed '1d'
        return 0
    fi

    # Validate the required integration arguments.
    if [[ $# -lt 3 || ! $1 =~ ^[0-9]+$ ]]; then
        echo 'Usage: p8_integrate_cl <source_cl> <from_branch> <to_branch> [DVS options ...]' >&2
        echo 'DVS options: axl, rm, mods, pvs, or a quoted raw keyword.' >&2
        return 2
    fi

    # Keep the integration inputs and leave remaining arguments for DVS.
    local source_cl=$1
    local from_branch=$2
    local to_branch=$3
    local output new_cl
    shift 3

    # Reuse hm for branch mapping, integration, generic bugs, and trivial resolves.
    if ! output=$(hm integrate "$source_cl" noask to "$to_branch" 2>&1); then
        printf '%s\n' "$output" >&2
        return 1
    fi
    printf '%s\n' "$output"

    # Extract the destination changelist created by hm.
    if [[ $output =~ Created[[:space:]]new[[:space:]]changelist[[:space:]]([0-9]+) ]]; then
        new_cl=${BASH_REMATCH[1]}
    else
        echo 'ERROR: unable to determine the integration changelist' >&2
        return 1
    fi

    # Rewrite the first description line as "(I from->to) original title".
    if ! p4 change -o "$new_cl" |
        awk -v prefix="(I ${from_branch}->${to_branch}) " '
            # Enter the changelist Description field.
            /^Description:/ {
                in_description = 1
            }

            # Replace the hm integration marker on the first description line.
            in_description && /^\t[^[:space:]]/ {
                sub(/^\t\(I[^)]*\)[[:space:]]*/, "\t")
                sub(/^\t/, "\t" prefix)
                in_description = 0
            }

            # Preserve the complete changelist specification.
            { print }
        ' |
        p4 change -i -u >/dev/null
    then
        echo "ERROR: unable to update integration CL $new_cl description" >&2
        return 1
    fi

    # Reuse the standalone helper for DVS submission and link maintenance.
    p8_test_dvs "$new_cl" "$@"
}
