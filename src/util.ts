export type Failure = {
    success: false, 
    error?: string
}
export type Success<T> = {
    success: true,
    value: T
}

export type Try<T> = Failure | Success<T>

export function Failure(error?: string): Failure {
    return {
        success: false,
        error: error
    };
}
export function Success<T>(value: T): Success<T> {
    return {
        success: true,
        value: value
    };
}
export function isFailure<T>(obj: Try<T>): obj is Failure {
    return !obj.success;
}
export function isSuccess<T>(obj: Try<T>): obj is Success<T> {
    return obj.success;
}