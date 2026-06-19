import { Request, Response, NextFunction } from "express";

export class AppError extends Error {
  constructor(
    public statusCode: number,
    public error: string,
    message: string
  ) {
    super(message);
  }
}

export function errorMiddleware(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
) {
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      error: err.error,
      message: err.message,
      statusCode: err.statusCode,
    });
  }

  if ((err as any).code === "P2002") {
    return res.status(409).json({
      error: "DUPLICATE_EMAIL",
      message: "El correo electrónico ya está registrado",
      statusCode: 409,
    });
  }

  console.error("[ERROR]", err);
  return res.status(500).json({
    error: "INTERNAL_ERROR",
    message: "Error interno del servidor",
    statusCode: 500,
  });
}
