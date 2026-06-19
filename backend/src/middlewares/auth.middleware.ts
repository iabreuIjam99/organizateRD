import { Request, Response, NextFunction } from "express";
import { verifyToken } from "../services/auth.service";

export interface AuthRequest extends Request {
  userId?: string;
  userEmail?: string;
  userType?: string;
}

export function authMiddleware(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith("Bearer ")) {
    return res.status(401).json({
      error: "UNAUTHORIZED",
      message: "Token de acceso requerido",
      statusCode: 401,
    });
  }

  const token = header.split(" ")[1];
  try {
    const decoded = verifyToken(token);
    req.userId = decoded.userId;
    req.userEmail = decoded.email;
    req.userType = decoded.userType;
    next();
  } catch {
    return res.status(401).json({
      error: "INVALID_TOKEN",
      message: "Token inválido o expirado",
      statusCode: 401,
    });
  }
}
