import { Response, NextFunction } from "express";
import { AuthRequest } from "../middlewares/auth.middleware";
import { AppError } from "../middlewares/error.middleware";
import {
  hashPassword,
  comparePassword,
  generateToken,
  findUserByEmail,
  createUser,
  findUserById,
} from "../services/auth.service";
import { RegisterInput, LoginInput } from "../types/auth.types";

export async function register(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  try {
    const { email, password, name, rncCedula, userType } =
      req.body as RegisterInput;

    if (!email || !password || !name || !rncCedula || !userType) {
      throw new AppError(400, "VALIDATION_ERROR", "Todos los campos son requeridos");
    }
    if (password.length < 6) {
      throw new AppError(400, "VALIDATION_ERROR", "La contraseña debe tener al menos 6 caracteres");
    }
    if (!["INDIVIDUAL", "PYME"].includes(userType)) {
      throw new AppError(400, "VALIDATION_ERROR", "Tipo de usuario inválido");
    }

    const existing = await findUserByEmail(email);
    if (existing) {
      throw new AppError(409, "DUPLICATE_EMAIL", "El correo ya está registrado");
    }

    const passwordHash = await hashPassword(password);
    const user = await createUser({
      email,
      passwordHash,
      name,
      rncCedula,
      userType,
    });

    const token = generateToken({
      userId: user.id,
      email: user.email,
      userType: user.userType,
    });

    res.status(201).json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        rncCedula: user.rncCedula,
        userType: user.userType,
      },
      token,
    });
  } catch (err) {
    next(err);
  }
}

export async function login(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  try {
    const { email, password } = req.body as LoginInput;

    if (!email || !password) {
      throw new AppError(400, "VALIDATION_ERROR", "Correo y contraseña requeridos");
    }

    const user = await findUserByEmail(email);
    if (!user) {
      throw new AppError(401, "INVALID_CREDENTIALS", "Credenciales inválidas");
    }

    const valid = await comparePassword(password, user.passwordHash);
    if (!valid) {
      throw new AppError(401, "INVALID_CREDENTIALS", "Credenciales inválidas");
    }

    const token = generateToken({
      userId: user.id,
      email: user.email,
      userType: user.userType,
    });

    res.json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        rncCedula: user.rncCedula,
        userType: user.userType,
      },
      token,
    });
  } catch (err) {
    next(err);
  }
}

export async function me(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  try {
    const user = await findUserById(req.userId!);
    if (!user) {
      throw new AppError(404, "USER_NOT_FOUND", "Usuario no encontrado");
    }

    res.json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        rncCedula: user.rncCedula,
        userType: user.userType,
      },
    });
  } catch (err) {
    next(err);
  }
}
