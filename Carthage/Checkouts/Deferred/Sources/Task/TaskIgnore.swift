//
//  TaskIgnore.swift
//  Deferred
//
//  Created by Zachary Waldowski on 4/15/16.
//  Copyright © 2015-2016 Big Nerd Ranch. Licensed under MIT.
//

#if SWIFT_PACKAGE
import Deferred
#endif

extension Task {
    /// Returns a task that ignores the successful completion of this task.
    ///
    /// This is semantically identical to the following:
    ///
    ///     myTask.map { _ in }
    ///
    /// But behaves more efficiently.
    ///
    /// The resulting task is cancellable in the same way the receiving task is.
    ///
    /// - see: map(transform:)
    public func ignored() -> Task<Void> {
        let future = every { (result) -> Task<Void>.Result in
            result.withValues(ifLeft: Task<Void>.Result.failure, ifRight: { _ in Task<Void>.Result.success(()) })
        }

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        return Task<Void>(future: future, progress: progress)
#else
        return Task<Void>(future: future, cancellation: cancel)
#endif
    }
}
