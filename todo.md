# Recent Updates

## Completed Maintenance Tasks
- [x] Standardized script headers with consistent format across all .sh files and PKGBUILD
- [x] Updated usage reference from "pickles-linux -h" to "pickles-update -h"
- [x] Added progress bars to curl downloads in AUR query scripts

---

# TODO: Make pickles-update a full replacement for paru

## Overview
Transform pickles-update from a simple wrapper into a comprehensive AUR helper with functionality comparable to paru, including package searching, information display, dependency resolution, and advanced package management features.

## Core Functionality to Add

### 1. Package Search
- Implement `-Ss` option for searching packages in official repos and AUR
- Support regex patterns
- Display package name, version, description, and repository
- Handle both official and AUR search results

### 2. Package Information
- Implement `-Si` option for package information from official repos
- Implement `-Sii` for detailed information including dependencies
- Add AUR package information display
- Show package size, dependencies, conflicts, etc.

### 3. Local Package Query
- Implement `-Q` options for querying local packages
- `-Q` : list all installed packages
- `-Qi` : show info for installed package
- `-Qs` : search in installed packages
- `-Qe` : list explicitly installed packages
- `-Qm` : list foreign packages (AUR)

### 4. Package Removal
- Implement `-R` option for removing packages
- Handle dependency checking and orphan removal
- Add `-Rs` for recursive removal
- Add `-Rns` for removal without saving config files

### 5. Package Cleaning
- Implement `-Sc` for cleaning package cache
- Implement `-Scc` for cleaning all cached versions
- Add AUR build directory cleanup

### 6. Dependency Resolution
- Improve dependency resolution for AUR packages
- Handle virtual packages and providers
- Resolve conflicts automatically
- Show dependency tree

### 7. PKGBUILD Review
- Add option to review PKGBUILD before building AUR packages
- Display PKGBUILD content
- Allow editing before build
- Show .SRCINFO if available

### 8. Build Options
- Add `--skipreview` to skip PKGBUILD review
- Add `--noconfirm` for automated builds
- Support custom makepkg flags
- Handle build failures gracefully

### 9. Configuration Enhancements
- Add more config options:
  - `review_pkgbuild=true/false`
  - `skip_pgpsign=false`
  - `clean_after_build=true`
  - `search_limit=50`
- Support for different AUR instances

### 10. Error Handling and Logging
- Improve error messages
- Better logging of build processes
- Recovery from failed builds
- Detailed error reporting

### 11. Interactive Features
- Add interactive mode for package selection
- Menu-driven interface for complex operations
- Progress indicators for long operations

### 12. Advanced Options
- Implement `--needed` to skip already up-to-date packages
- Add `--ignore` for ignoring packages
- Support for `--asdeps` and `--asexplicit`
- Handle package groups

### 13. Performance Optimizations
- Parallel downloads for AUR info
- Caching of AUR data
- Optimized search algorithms
- Reduced API calls

### 14. Compatibility
- Ensure compatibility with pacman options
- Support for all common paru flags
- Backward compatibility with existing scripts

### 15. Documentation and Help
- Update man page with all new options
- Improve help text
- Add examples for complex operations
- Create user guide

## Implementation Priority

1. **High Priority** (Essential for basic functionality)
   - Package search (-Ss)
   - Package information (-Si)
   - Local package query (-Q options)
   - Package removal (-R)

2. **Medium Priority** (Important features)
   - Package cleaning (-Sc)
   - PKGBUILD review
   - Better dependency resolution
   - Configuration enhancements

3. **Low Priority** (Nice-to-have features)
   - Interactive mode
   - Advanced options
   - Performance optimizations
   - Extended documentation

## Technical Considerations

- **API Usage**: Implement efficient AUR RPC API usage
- **Caching**: Add intelligent caching for AUR data
- **Security**: Maintain PGP verification for AUR packages
- **Dependencies**: Ensure all required tools are available
- **Testing**: Comprehensive testing with various package scenarios
- **Code Structure**: Refactor for maintainability with new features

## Breaking Changes
- Some option behaviors may change to match paru
- Configuration file format may need updates
- Default behaviors might change for better usability

## Timeline
- Phase 1: Core package management (search, info, query, remove)
- Phase 2: Advanced features (cleaning, review, dependencies)
- Phase 3: Polish and optimization