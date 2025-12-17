# fireflag Roadmap

**Last Updated**: 2025-12-17
**Current Version**: 0.1.0
**Overall Progress**: 40%

## Current Status

| Component | Status | Completion |
|-----------|--------|------------|
| RSR Compliance | Complete | 100% |
| Security | Complete | 100% |
| Documentation | Foundation | 50% |
| Testing | Minimal | 10% |
| Core Functionality | Pending | 0% |

## Milestones

### v0.1.0 - Infrastructure (Current)
**Status**: 40% Complete

- [x] RSR-compliant CI/CD pipeline
- [x] Multi-platform mirroring (GitHub, GitLab, Bitbucket)
- [x] SPDX license headers
- [x] SHA-pinned GitHub Actions
- [x] RFC 9116 security.txt
- [x] SECURITY.md disclosure policy
- [x] flake.nix (Nix fallback)
- [x] Containerfile (OCI-compliant)
- [x] guix.scm (primary package manager)
- [ ] Implement justfile recipes

---

### v0.2.0 - Core Functionality
**Status**: Pending

**Goals**:
- Feature flag data model design
- Storage backend abstraction
- Basic CRUD operations
- Initial test suite (target: 50% coverage)

**Tasks**:
- [ ] Design feature flag schema (Guile Scheme)
- [ ] Implement in-memory storage backend
- [ ] Create flag evaluation engine
- [ ] Add basic API (if applicable)
- [ ] Write unit tests
- [ ] Implement justfile recipes (build, test, lint)

---

### v0.5.0 - Feature Complete
**Status**: Pending

**Goals**:
- All planned features implemented
- Test coverage > 70%
- API stability

**Tasks**:
- [ ] Persistent storage backend options
- [ ] Flag targeting/segmentation rules
- [ ] Environment-based configuration
- [ ] Comprehensive documentation
- [ ] Integration tests
- [ ] Performance benchmarks

---

### v1.0.0 - Production Release
**Status**: Pending

**Goals**:
- Production-ready release
- Comprehensive test coverage (>80%)
- Security audit complete
- Full documentation

**Tasks**:
- [ ] Security audit
- [ ] Performance optimization
- [ ] User documentation
- [ ] API reference documentation
- [ ] Deployment guides
- [ ] Release notes

---

## Technology Stack (RSR-Compliant)

| Layer | Technology | Status |
|-------|------------|--------|
| Primary Language | Guile Scheme (Tier 2) | Planned |
| Fallback | Rust (Tier 1) | If needed |
| Package Manager | Guix (primary) | Ready |
| Fallback PM | Nix | Ready |
| Container | Containerfile (OCI) | Ready |
| CI/CD | GitHub Actions + GitLab CI | Active |
| Security | CodeQL, OSSF Scorecard | Active |

## Blocked Items

None critical.

## How to Contribute

See [CONTRIBUTING guidelines](https://github.com/hyperpolymath/fireflag/blob/main/CONTRIBUTING.adoc) (to be added).

## References

- [STATE.scm](STATE.scm) - Machine-readable project state
- [RSR_COMPLIANCE.adoc](RSR_COMPLIANCE.adoc) - Compliance status
- [META.scm](META.scm) - Architecture decisions
