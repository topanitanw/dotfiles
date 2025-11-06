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
    local opened_files=$(p4 opened 2>/dev/null | cut -d "#" -f 1 | cut -d " " -f 1)

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
    local file_count=$(echo "$opened_files" | wc -l)
    echo "Found $file_count opened file(s)"
    echo "Reopening files to changelist $clno..."

    # Reopen each file to the specified changelist
    local success_count=0
    local fail_count=0

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
    local p8_info_output=$(p4 info 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "Error: Failed to get p4 info"
        return 1
    fi

    # Extract Client root for P4ROOT
    local client_root=$(echo "$p8_info_output" | grep "^Client root:" | cut -d ":" -f 2- | sed 's/^[[:space:]]*//')

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
    local p8_info_output=$(p4 info 2>/dev/null)

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
    echo "📋 P4 INFO:"
    echo "----------"
    local p4_info_output=$(p4 info 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$p4_info_output" ]; then
        echo "$p4_info_output"
    else
        echo "❌ Failed to get p4 info or no connection to Perforce server"
        return 1
    fi
    echo

    # Display P4 Environment Variables
    echo "🌍 P4 ENVIRONMENT VARIABLES:"
    echo "----------------------------"
    echo "P4CONFIG = ${P4CONFIG:-<not set>}"
    echo "P4EDITOR = ${P4EDITOR:-<not set>}"
    echo "P4DIFF = ${P4DIFF:-<not set>}"
    echo "P4ROOT = ${P4ROOT:-<not set>}"
    echo "P4USER = ${P4USER:-<not set>}"
    echo "P4CLIENT = ${P4CLIENT:-<not set>}"
    echo "P4PORT = ${P4PORT:-<not set>}"
    echo

    # Display P4 Opened Files
    echo "📂 OPENED FILES:"
    echo "----------------"
    local opened_output=$(p4 opened 2>/dev/null)
    if [ $? -eq 0 ]; then
        if [ -n "$opened_output" ]; then
            echo "$opened_output"
            echo
            # Count opened files
            local file_count=$(echo "$opened_output" | wc -l | tr -d ' ')
            echo "Total opened files: $file_count"
        else
            echo "No files are currently opened"
        fi
    else
        echo "❌ Failed to get opened files"
    fi
    echo

    # Display Current Opened Changelist(s)
    echo "📝 CURRENT OPENED CHANGELIST(s):"
    echo "--------------------------------"
    if [ -n "$opened_output" ]; then
        # Extract unique changelist numbers from opened files
        # Format: //depot/path#1 - edit change 12345 (text)
        local changelists=$(echo "$opened_output" | grep -o 'change [0-9]*' | cut -d' ' -f2 | sort -u)
        
        if [ -n "$changelists" ]; then
            while IFS= read -r cl; do
                if [ -n "$cl" ]; then
                    if [ "$cl" = "default" ]; then
                        echo "🔄 Default changelist"
                    else
                        echo "🔢 Changelist: $cl"
                        # Get changelist description
                        local cl_desc=$(p4 describe -s "$cl" 2>/dev/null | head -n 10)
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

    echo "📝 PENDING CHANGELISTS:"
    echo "--------------------------------"
    p4 changes -u ${P4USER} -c ${P4CLIENT} -s pending

    echo "=========================================="
    return 0
}
